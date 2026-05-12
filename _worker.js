// _worker.js — AURUM Restaurant
// Cloudflare Pages Worker — handles API + serves pages
// Place this file in root of your GitHub repo

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;
    const method = request.method;

    // ── CORS preflight
    if (method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders() });
    }

    // ── API: GET all data (menu + settings) for website
    if (path === '/api/data' && method === 'GET') {
      try {
        const [sr, mr] = await Promise.all([
          env.DB.prepare("SELECT key,value FROM settings").all(),
          env.DB.prepare("SELECT * FROM menu_items WHERE active=1 ORDER BY category,sort_order").all()
        ]);
        const settings = Object.fromEntries(sr.results.map(r => [r.key, r.value]));
        const menu = { starters:[], mains:[], desserts:[], drinks:[] };
        for (const item of mr.results) if (menu[item.category]) menu[item.category].push(item);
        return jsonRes({ settings, menu });
      } catch(e) { return jsonRes({ error: e.message }, 500); }
    }

    // ── API: POST reservation
    if (path === '/api/reservation' && method === 'POST') {
      try {
        const b = await request.json();
        if (!b.first_name||!b.last_name||!b.email||!b.phone||!b.date||!b.guests)
          return jsonRes({ error: 'Missing required fields' }, 400);
        await env.DB.prepare(
          `INSERT INTO reservations(first_name,last_name,email,phone,date,guests,occasion,notes)
           VALUES(?,?,?,?,?,?,?,?)`
        ).bind(b.first_name,b.last_name,b.email,b.phone,b.date,b.guests,b.occasion||'',b.notes||'').run();
        return jsonRes({ success: true });
      } catch(e) { return jsonRes({ error: e.message }, 500); }
    }

    // ── API: Admin (GET + POST)
    if (path === '/api/admin') {
      const pwd = request.headers.get('X-Admin-Password') || '';
      const stored = await env.DB.prepare("SELECT value FROM settings WHERE key='admin_password'").first();
      if (!stored || pwd !== stored.value) return jsonRes({ error: 'Unauthorized' }, 401);

      if (method === 'GET') {
        try {
          const [sr, mr, rr] = await Promise.all([
            env.DB.prepare("SELECT key,value FROM settings WHERE key!='admin_password'").all(),
            env.DB.prepare("SELECT * FROM menu_items ORDER BY category,sort_order").all(),
            env.DB.prepare("SELECT * FROM reservations ORDER BY created_at DESC LIMIT 200").all()
          ]);
          return jsonRes({
            settings: Object.fromEntries(sr.results.map(r=>[r.key,r.value])),
            menu: mr.results,
            reservations: rr.results
          });
        } catch(e) { return jsonRes({ error: e.message }, 500); }
      }

      if (method === 'POST') {
        try {
          const b = await request.json();
          if (b.action === 'update_setting') {
            await env.DB.prepare("INSERT OR REPLACE INTO settings(key,value,updated_at) VALUES(?,?,CURRENT_TIMESTAMP)").bind(b.key,b.value).run();
            return jsonRes({ success: true });
          }
          if (b.action === 'add_menu') {
            await env.DB.prepare(`INSERT INTO menu_items(category,name,description,price,badge,tag,image_url,sort_order) VALUES(?,?,?,?,?,?,?,?)`)
              .bind(b.category,b.name,b.description||'',b.price,b.badge||'',b.tag||'',b.image_url||'',b.sort_order||0).run();
            return jsonRes({ success: true });
          }
          if (b.action === 'update_menu') {
            await env.DB.prepare(`UPDATE menu_items SET name=?,description=?,price=?,badge=?,tag=?,image_url=?,active=?,updated_at=CURRENT_TIMESTAMP WHERE id=?`)
              .bind(b.name,b.description||'',b.price,b.badge||'',b.tag||'',b.image_url||'',b.active,b.id).run();
            return jsonRes({ success: true });
          }
          if (b.action === 'delete_menu') {
            await env.DB.prepare("DELETE FROM menu_items WHERE id=?").bind(b.id).run();
            return jsonRes({ success: true });
          }
          if (b.action === 'update_reservation') {
            await env.DB.prepare("UPDATE reservations SET status=? WHERE id=?").bind(b.status,b.id).run();
            return jsonRes({ success: true });
          }
          return jsonRes({ error: 'Unknown action' }, 400);
        } catch(e) { return jsonRes({ error: e.message }, 500); }
      }
    }

    // ── Serve static files (Pages handles this automatically)
    return env.ASSETS.fetch(request);
  }
};

function corsHeaders() {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type,X-Admin-Password'
  };
}
function jsonRes(data, status=200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json', ...corsHeaders() }
  });
}

-- AURUM Restaurant - Database Setup
-- Run once: wrangler d1 execute aurum-restaurant --file=schema.sql --remote

CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS menu_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  price TEXT NOT NULL,
  badge TEXT,
  tag TEXT,
  image_url TEXT,
  sort_order INTEGER DEFAULT 0,
  active INTEGER DEFAULT 1,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reservations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  date TEXT NOT NULL,
  guests TEXT NOT NULL,
  occasion TEXT,
  notes TEXT,
  status TEXT DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Default Settings
INSERT OR IGNORE INTO settings (key, value) VALUES
  ('restaurant_name',  'AURUM'),
  ('hero_tagline',     'Est. 2008 · Casablanca'),
  ('tagline',          'Where gastronomy meets artistry'),
  ('about_text1',      'Born from a passion for transforming the finest seasonal ingredients into memorable experiences, AURUM has been Casablanca''s crown jewel of fine dining for over seventeen years.'),
  ('about_text2',      'Our culinary philosophy centers on the marriage of classical French technique with the bold, aromatic soul of Moroccan cuisine — a dialogue between two great culinary traditions.'),
  ('chef_name',        'Chef Karim Mansour'),
  ('phone',            '+212 633 565 100'),
  ('whatsapp',         '212633565100'),
  ('email',            'hello@aurum.ma'),
  ('address',          'Marina Juice Hattab, El Alam, Av. Colonel Driss El Allam, Casablanca 20670'),
  ('hours_weekday',    '08:00 – 23:49'),
  ('hours_weekend',    '08:00 – 23:49'),
  ('admin_password',   'aurum2025');

-- Menu Items
INSERT OR IGNORE INTO menu_items (category, name, description, price, badge, tag, image_url, sort_order) VALUES
  ('starters','Seared Foie Gras','Pan-seared duck foie gras with fig compote, brioche toast, and aged balsamic reduction.','320 MAD','Chef''s Pick','Signature Starter','https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=900&q=90&auto=format&fit=crop',1),
  ('starters','Oysters Gratinées','Half dozen Oualidia oysters, lemon butter, sea herbs, crispy shallots and Champagne foam.','280 MAD','Seasonal','From the Sea','https://images.unsplash.com/photo-1559181567-c3190ca9be46?w=900&q=90&auto=format&fit=crop',2),
  ('starters','Heritage Tomato Tart','Heirloom tomatoes, whipped burrata, aged Parmesan tuile, micro basil oil and smoked salt.','195 MAD','Vegetarian','Garden Fresh','https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=900&q=90&auto=format&fit=crop',3),
  ('mains','Wagyu Tenderloin','A5 Wagyu beef, truffle jus, bone marrow butter, roasted garlic pomme purée and micro greens.','780 MAD','Chef''s Pick','Prime Cut','https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=900&q=90&auto=format&fit=crop',1),
  ('mains','Sea Bass en Papillote','Wild-caught sea bass, saffron fennel broth, confit lemon, capers and crispy calamari.','520 MAD','Seasonal','From the Sea','https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=900&q=90&auto=format&fit=crop',2),
  ('mains','Slow-Braised Lamb','48-hour braised lamb shoulder, chermoula crust, preserved lemon couscous and harissa jus.','620 MAD','Signature','Moroccan Heritage','https://images.unsplash.com/photo-1574484284002-952d92456975?w=900&q=90&auto=format&fit=crop',3),
  ('desserts','Chocolate Soufflé','Valrhona dark chocolate soufflé, Tahitian vanilla ice cream and Timut pepper caramel sauce.','185 MAD','Must Order','Sweet Finale','https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900&q=90&auto=format&fit=crop',1),
  ('desserts','Orange Blossom Tart','Moroccan orange blossom cream, almond frangipane, candied citrus and rose water chantilly.','155 MAD','Signature','Patisserie','https://images.unsplash.com/photo-1488477181946-6428a0291777?w=900&q=90&auto=format&fit=crop',2),
  ('desserts','Argan & Honey Gelato','House-made argan oil gelato, wild thyme honey, toasted pine nuts and almond brittle.','120 MAD','Vegetarian','Artisan','https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=900&q=90&auto=format&fit=crop',3),
  ('drinks','Château Les Cèdres','Grand Cru Moroccan red, Cabernet Sauvignon & Syrah blend. Bold tannins, cedar and dark fruit.','650 MAD','750ml','Fine Wine','https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=900&q=90&auto=format&fit=crop',1),
  ('drinks','The Golden Souk','Oud-smoked bourbon, ras el hanout honey, fresh ginger, lemon and 24K gold leaf finish.','185 MAD','Signature','Signature Cocktail','https://images.unsplash.com/photo-1544145945-f90425340c7e?w=900&q=90&auto=format&fit=crop',2),
  ('drinks','Moroccan Mint Ceremony','Gunpowder green tea, fresh Meknes mint, honey, candied ginger and a rose petal garnish.','75 MAD','Traditional','Non-Alcoholic','https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=900&q=90&auto=format&fit=crop',3);

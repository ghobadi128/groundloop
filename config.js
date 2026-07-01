/* ============================================================
   GroundLoop configuration
   Paste your keys below. With Supabase keys filled in, the app
   runs LIVE (shared cloud database, real accounts, realtime).
   Left blank, it runs in DEMO mode (data saved in your browser).
============================================================ */
window.GROUNDLOOP_CONFIG = {

  /* --- Supabase (free Postgres DB + auth + realtime) ---
     Get these from: Supabase dashboard → Project Settings → API */
  SUPABASE_URL:      "",   // e.g. "https://abcd1234.supabase.co"
  SUPABASE_ANON_KEY: "",   // the "anon / public" key

  /* --- Stripe (subscriptions with 30-day free trial) ---
     Create two Payment Links in Stripe (Products → Payment Links).
     Set a 30-day free trial on the recurring price.
     Paste the resulting links here. Leave blank to use demo checkout. */
  STRIPE_MONTHLY_LINK: "",  // e.g. "https://buy.stripe.com/xxxxxxxx"  ($6/mo)
  STRIPE_ANNUAL_LINK:  "",  // e.g. "https://buy.stripe.com/yyyyyyyy"  ($50/yr)

  /* --- Delivery partner / courier integrations --- */
  DELIVERY: {
    // Where collectors are sent to order an on-demand courier:
    uber:     "https://www.uber.com/us/en/deliver/",        // Uber Direct / Connect
    doordash: "https://www.doordash.com/",                  // DoorDash
    // Where drivers sign up to earn:
    uberDriverSignup:     "https://www.uber.com/signup/drive/",
    doordashDasherSignup: "https://dasher.doordash.com/en-us/signup",
  },

  /* Default map center if a user blocks location (lat,lng). */
  DEFAULT_CENTER: { lat: 40.7220, lng: -73.9970 }, // NYC
};

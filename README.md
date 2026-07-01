# GroundLoop ☕🔁

A real-time, location-based marketplace that connects coffee shops with gardeners, composters, mushroom growers, schools, and artists to give used coffee grounds and other organic byproducts a second life.

The whole app is **static files** (`index.html` + `config.js`), so it hosts for free on GitHub Pages and scales automatically. It runs in two modes:

- **DEMO mode** (default, no keys): everything works instantly, data saved in your browser. Great for trying it.
- **LIVE mode** (add Supabase keys): real accounts, a shared cloud database, and real-time updates across all users' devices.

---

## 1. Get it online (GitHub Pages — free)

1. Create a new GitHub repo and upload these files (keep the folder structure, including `.github/workflows/deploy.yml`).
2. In the repo: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. Push to `main`. The included workflow publishes the site. Your public URL appears under **Settings → Pages** (looks like `https://<you>.github.io/<repo>/`).

That's it — the app is live. It works in DEMO mode immediately. Add the keys below to make it LIVE.

---

## 2. Connect the database (Supabase — free, reliable, real-time)

This is where collectors' and coffee shops' info is stored securely in the cloud.

1. Create a project at https://supabase.com (free tier).
2. Open **SQL Editor**, paste the entire contents of `schema.sql`, and click **Run**. This creates all tables, security rules, and turns on real-time.
3. Go to **Authentication → Providers → Email** and turn **OFF "Confirm email"** so new users can sign in instantly (optional — leave on if you want email confirmation).
4. Go to **Project Settings → API** and copy your **Project URL** and **anon public key**.
5. Open `config.js` and paste them:
   ```js
   SUPABASE_URL:      "https://YOURPROJECT.supabase.co",
   SUPABASE_ANON_KEY: "eyJhbGc...your-anon-key...",
   ```
6. Commit/push. The app now shows a **LIVE** badge, stores everyone's data in Postgres, and updates listings in real time.

**Location / near-me** works automatically: the app asks the browser for GPS, centers the map on the user, and sorts listings by distance. (Browsers only grant location over `https://`, which GitHub Pages provides.)

---

## 3. Payments (Stripe — for subscriptions + 30-day free trial)

Collectors get a 30-day free trial; after that, reserving and delivery require a subscription ($6/mo or $50/yr). Shops and drivers are always free.

No backend needed to start — use **Stripe Payment Links**:

1. In Stripe: **Products → Add product** ("GroundLoop Plus"), add a recurring price of **$6/month**, and under the price set a **30-day free trial**. Repeat for a **$50/year** price.
2. **Payment Links → Create link** for each price. In the link's settings, set the success URL back to your app with a flag:
   - Monthly link success URL: `https://<your-pages-url>/?paid=monthly`
   - Annual link success URL: `https://<your-pages-url>/?paid=annual`
3. Paste the two links into `config.js`:
   ```js
   STRIPE_MONTHLY_LINK: "https://buy.stripe.com/xxxx",
   STRIPE_ANNUAL_LINK:  "https://buy.stripe.com/yyyy",
   ```
Now the Subscribe buttons open real Stripe checkout (the user's email and ID are passed along), and on return the app unlocks Plus.

> For production-grade billing (instant, tamper-proof unlock and cancellations), add a small webhook that listens to Stripe `customer.subscription.*` events and flips the user's `plan` to `active` in Supabase. Supabase Edge Functions work well for this. The Payment Link flow above is the fast MVP path. Leave the keys blank to use the built-in demo checkout instead.

---

## 4. Delivery (Uber / DoorDash integration)

The app supports three delivery paths, chosen by the collector when they tap **Request delivery**:

- **GroundLoop driver** — an in-app delivery partner accepts the job, marks en route, then delivered.
- **Uber courier** — opens Uber Connect / Uber Direct to order an on-demand courier.
- **DoorDash** — opens DoorDash for on-demand delivery.

Drivers can sign up to earn through partner networks straight from the **Jobs** tab (links to Uber driver and DoorDash Dasher signup). These links are configurable in `config.js` under `DELIVERY`.

> Deep links cover the consumer/driver onboarding path with no API keys. For fully automated, in-app courier dispatch (auto-create a delivery, live tracking), apply for **Uber Direct** (business API) and wire its API server-side, then call it from the delivery flow.

---

## Roadmap image

`roadmap.svg` is a shareable "How it works" graphic for marketing or a pitch deck. The same flow is built into the landing page so visitors understand the app before signing up.

## Demo accounts (DEMO mode only — password `demo`)

`collector@demo.com` (on trial) · `shop@demo.com` · `driver@demo.com` · `admin@demo.com`

## Files

| File | What it is |
|---|---|
| `index.html` | The entire app (UI, map, auth, realtime, payments, delivery) |
| `config.js` | Your keys (Supabase, Stripe, delivery links) |
| `schema.sql` | Run once in Supabase to create the database |
| `roadmap.svg` | "How it works" marketing graphic |
| `.github/workflows/deploy.yml` | Auto-deploys to GitHub Pages on push |

## Success metrics tracked

Active coffee shops, collectors, listings, pounds of material reused, pickup/delivery completion rate, monthly active users, paid subscribers, and MRR (in the Admin tab).

 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/README.md b/README.md
new file mode 100644
index 0000000000000000000000000000000000000000..c99df29698c2b2cf6aa6cdada9899c085b80554c
--- /dev/null
+++ b/README.md
@@ -0,0 +1,61 @@
+# Flip Finder
+
+Flip Finder is an iOS app concept for identifying products worth flipping for profit across marketplaces like eBay, Facebook Marketplace, and Poshmark.
+
+This repository includes:
+
+1. `FlipFinderCore` Swift package with reusable opportunity scoring and profit math.
+2. A lightweight SwiftUI iOS template (`iOSAppTemplate/FlipFinder`) showing a 4-tab UX:
+   - **Deals**: loads listings through a real API-ready service abstraction with fallback handling.
+   - **Analyzer**: instant profit + ROI calculator.
+   - **Saved**: persisted watchlist using `UserDefaults`.
+   - **Settings**: legal links, support contact, and account-data deletion action.
+
+## Core value proposition
+
+- Detect profitable listings fast.
+- Reduce bad buys with transparent profit math.
+- Prioritize flips with a confidence score and recommendation (`Buy now`, `Watch`, `Pass`).
+
+## App Store readiness progress
+
+### Implemented in this template
+- API-ready deal feed service (`MarketplaceAPIDealFeedService`) with bearer-token auth support.
+- Fallback strategy to mock data for local development (`FallbackDealFeedService`).
+- Saved watchlist persistence (`SavedDealsStore` with `UserDefaultsSavedDealsStore`).
+- Compliance and support settings:
+  - Privacy policy link
+  - Terms of service link
+  - Support email
+  - Account-data deletion flow
+- Observability hooks via `AnalyticsTracking`.
+- Accessibility basics:
+  - Labels/hints for loading and refresh actions
+  - Empty and error states using `ContentUnavailableView`
+
+### Still required before shipping to App Store
+- Deploy and validate production backend APIs with real credentials.
+- Wire production analytics/crash reporting SDKs.
+- Complete App Store Connect submission assets and privacy disclosures.
+- Run full TestFlight and on-device QA.
+
+## Release docs
+- `docs/AppStoreReleaseChecklist.md`
+- `docs/AppStoreConnectMetadata.md`
+
+## Run tests
+
+```bash
+swift test
+```
+
+## Suggested next build steps
+
+1. Open Xcode and create an iOS app target named `FlipFinder`.
+2. Add this repo's `FlipFinderCore` package as a local package dependency.
+3. Copy the files under `iOSAppTemplate/FlipFinder` into the target.
+4. Replace mock/fallback behavior with your production service configuration.
+
+## App icon
+
+An app icon asset catalog has been added at `iOSAppTemplate/FlipFinder/Assets.xcassets/AppIcon.appiconset` with a 1024x1024 `AppIcon-1024.png` image and `Contents.json` metadata so it can be dropped directly into an Xcode iOS target.
 
EOF
)

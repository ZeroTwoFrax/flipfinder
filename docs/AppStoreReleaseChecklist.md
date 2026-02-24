# Flip Finder App Store Release Checklist

## Product & Backend
- [x] Feed architecture supports real API integration (`MarketplaceAPIDealFeedService`) with auth token support.
- [x] Fallback path exists for developer mode (`FallbackDealFeedService` to mock feed).
- [ ] Production API endpoint is live and validated with staging/prod credentials.

## Compliance & Legal
- [x] In-app Privacy Policy link.
- [x] In-app Terms of Service link.
- [x] In-app support email entry.
- [x] In-app account-data deletion action.
- [ ] Host final legal documents at production URLs and verify content with counsel.

## Quality & Observability
- [x] Analytics event interface added (`AnalyticsTracking`) with default tracker implementation.
- [x] Error-state UX for network failures.
- [ ] Wire production analytics/crash providers (Firebase/Sentry/etc).
- [ ] Complete TestFlight cycle on target devices.

## App Store Connect
- [x] App icon provided as 1024x1024 asset.
- [ ] Upload screenshots for all required display sizes.
- [ ] Fill app description, keywords, support URL, marketing URL.
- [ ] Complete App Privacy questionnaire.
- [ ] Submit build for App Review.

# DRAGONFLY WELLNESS HOMEPAGE - COMPREHENSIVE DESIGN & IMPLEMENTATION PLAN

## PROJECT OVERVIEW
Single-page wellness landing experience that serves as the gateway to a deeper coaching site. Focus on transformation, nature, and embodied wisdom with clean black/white/purple aesthetic using Picnic Club font.

---

## TECHNICAL ARCHITECTURE

### Tech Stack
- **Framework:** React (single .jsx artifact initially, can be broken into components later)
- **Styling:** Tailwind CSS + custom CSS for animations
- **Typography:** Picnic Club (display) + Lato (body)
- **Hosting:** HostGator (standard HTML/CSS/JS deployment)
- **Build Process:** Will need to be converted from React to static HTML/CSS/JS for HostGator

### File Structure Preparation
```
/dragonfly-site
  /assets
    /images
      - dragonfly-logo.png (small wordmark)
      - dragonfly-main.png (hero image)
      - botanical-elements/ (leaf illustrations)
      - wings-eye-mystical.png (from graphic 2)
    /fonts
      - PicnicClub-Regular.woff2
  /styles
    - main.css
  /scripts
    - animations.js
    - calendar-integration.js
    - analytics.js
  index.html
```

---

## DESIGN SYSTEM

### Color Palette
- **Primary Background:** #FFFFFF (white)
- **Primary Text:** #000000 (black)
- **Accent Purple:** #8B5CF6 (purple-600 in Tailwind)
- **Secondary Purple:** #A78BFA (purple-400)
- **Gray Tones:** #F9FAFB (gray-50), #6B7280 (gray-500)
- **Border/Divider:** #E5E7EB (gray-200)

### Typography Scale
- **Hero:** 96px (Picnic Club)
- **Section Headers:** 60px (Picnic Club)
- **Subsection Headers:** 48px (Picnic Club)
- **Card Titles:** 36px (Picnic Club)
- **Body Large:** 20px (Lato Light)
- **Body Standard:** 16px (Lato)
- **Small/Caption:** 14px (Lato Light)

### Spacing System
- Section padding: 96px vertical
- Card padding: 48px
- Element spacing: 24px standard, 16px compact
- Container max-width: 1280px

---

## PAGE STRUCTURE & SECTIONS

### 1. HEADER (Sticky, minimal)
- Small Dragonfly wordmark logo (top left, ~60px height)
- Subtle purple accent line (1px, 30% opacity) at bottom
- Transparent background with blur-on-scroll
- Height: 80px

### 2. HERO SECTION
```
- "Hello, Dragonfly!" (Picnic Club, 96px, black)
- Subtitle: "Welcome to a space of transformation..." (20px, gray-700)
- Subtle botanical illustration floating in background (top-right corner, 20% opacity)
- Vertical spacing: 120px top, 80px bottom
```

### 3. INTERACTIVE DRAGONFLY OFFERINGS
```
- Section label: "EXPLORE OUR OFFERINGS" (14px, uppercase, tracking-widest, gray-500)
- Dragonfly PNG centered (max-width: 700px)
- Subtle floating animation (2px vertical movement, 6s duration)
- Wing shimmer effect on hover (subtle opacity pulse)

Clickable Hotspots (positioned absolutely over wings):
  • Top-Left Wing: Meditational Walks
  • Top-Right Wing: Kitchen Sessions  
  • Bottom-Left Wing: Seasonal Containers
  • Bottom-Right Wing: Clothing Swaps

Hover State: 
  - Purple glow (subtle)
  - Cursor: pointer
  - 0.3s transition

Click Behavior → Modal Overlay
```

### 4. MODAL OVERLAY SYSTEM
```
Design:
- Full-screen semi-transparent backdrop (rgba(0,0,0,0.6))
- White modal card (600px max-width, rounded-3xl, shadow-2xl)
- 2px purple-600 border
- Backdrop blur effect
- Close button (top-right, 40px, hover: scale)

Animation In:
- Backdrop: fade in (300ms)
- Modal: scale from 0.95 + fade in (400ms, ease-out)
- Content: stagger fade-in (icon → title → description, 100ms delays)

Content Structure:
- Icon (lucide-react, 56px, purple-600)
- Title (Picnic Club, 48px, black)
- Description (Lato, 20px, gray-700, line-height: 1.7)
- Spacing: 24px between elements, 64px padding

Animation Out:
- Reverse of animation in (300ms, ease-in)
```

### 5. OFFERING NAVIGATION GRID (Below dragonfly)
```
4-column grid (2x2 on mobile)
Each card:
- Icon centered (40px)
- Title below (24px, Picnic Club)
- Padding: 32px
- Border: 2px transparent → purple-500 on hover
- Background: white → gray-50 on hover
- Rounded: 16px
- Transition: all 300ms
- Hover: scale(1.02)
```

### 6. CALENDAR SECTION
```
Container:
- Gray-50 background
- Rounded-3xl
- 64px padding
- Shadow-lg
- Max-width: 1000px, centered

Header:
- Calendar icon (40px, purple-600) + Title (Picnic Club, 60px)
- Horizontal flex layout, gap: 16px

Google Calendar Embed:
- Full-width iframe
- Height: 600px
- Responsive (adjust height on mobile)
- Border: 1px gray-200
- Rounded: 16px
- Margin-top: 32px

Integration Method:
- Use Google Calendar's public embed code
- Custom CSS to style the embed to match site aesthetic
- Auto-refresh: Use Google Calendar API to check for updates (webhook or polling)
```

### 7. SUBSTACK INTEGRATION SECTION
```
Header: "Words & Wisdom" (Picnic Club, 60px)
Subtitle: "Explore reflections on nature..." (20px, gray-600)

Recent Posts Display:
- Fetch via Substack RSS feed (https://yoursubstack.substack.com/feed)
- Parse XML to JSON
- Display 3 most recent posts

Post Card Design:
- Horizontal card layout
- Featured image (left, 200x200px, rounded-2xl)
- Content area (right):
  • Title (Picnic Club, 28px, black)
  • Excerpt (Lato, 16px, gray-600, 2 lines max)
  • Read More link (purple-600, hover: purple-700)
- Card spacing: 32px between cards
- Hover: subtle scale(1.01), shadow increase

Implementation:
- Use fetch() to get RSS feed
- Parse with DOMParser or xml2js library
- Cache results (localStorage, 1 hour TTL)
- Loading state: skeleton cards
- Error state: gentle message
```

### 8. PORTAL TO COACHING SITE ("Enter the Inner Realm")
```
Section Design:
- Black background (rounded-3xl)
- Purple glow effect (blur-3xl, 20% opacity, animated pulse)
- Mystical wings + eye graphic from IMG_2318 centered at top
- 96px padding

Content:
- Title: "Ready to go deeper?" (Picnic Club, 72px, white)
- Subtitle: "Step through the threshold..." (24px, gray-300)
- CTA Button: "Enter the Inner Realm" + Sparkles icon

Button Design:
- White background
- Black text
- Purple-500 border (2px)
- Rounded-full
- Padding: 24px 48px
- Font: 24px, medium
- Hover: scale(1.05), shadow-2xl, gap increase

PORTAL ANIMATION:
Phase 1 - Button Click (300ms):
  - Button: scale(0.95)
  - Emit purple particle burst from button

Phase 2 - Portal Opening (800ms):
  - Create circular portal overlay from button position
  - Expand portal circle to full screen
  - Portal: purple-to-black gradient, swirling animation
  - Wings + eye graphic scales up and fades in center
  - Ethereal glow pulses

Phase 3 - Vortex Effect (600ms):
  - Entire page content scales down and rotates slightly
  - Fade out to white
  - Swirling particle effects around edges

Phase 4 - Transition (400ms):
  - White flash
  - Fade in to coaching site
  - window.location.replace('[coaching-site-url]')

Technical Implementation:
  - Use CSS animations + transforms
  - Canvas element for particle effects
  - SVG for swirling portal gradient
  - RequestAnimationFrame for smooth 60fps
  - Total animation: ~2.2 seconds
```

### 9. FOOTER
```
Design:
- Simple centered layout
- Gray-200 border top (1px)
- 64px padding top
- Gray-500 text (14px)

Content:
- Copyright: "© 2025 Dragonfly"
- Tagline: "Where transformation takes wing" (italic)
- Social Media Icons (24px):
  • Instagram link
  • Facebook link
  • Icons: simple line icons, gray-500 → purple-600 on hover
  • Horizontal layout, gap: 24px
- Spacing: 16px between lines
```

---

## RESPONSIVE DESIGN STRATEGY

### Breakpoints
- **Mobile:** < 640px
- **Tablet:** 640px - 1024px
- **Desktop:** > 1024px

### Mobile Adaptations
1. **Hero:** 64px font size
2. **Dragonfly:** 
   - Reduce to 90% width
   - Increase hotspot sizes (easier tapping)
   - Stack offering grid 1 column
3. **Modal:** 
   - Full screen on mobile
   - 90% width on tablet
4. **Calendar:** Height reduce to 400px
5. **Substack cards:** Stack vertically
6. **Portal section:** Reduce padding to 48px, font sizes -20%

---

## BOTANICAL ILLUSTRATION SYSTEM

### Placement Strategy
- **Hero section:** Top-right corner, floating leaf cluster (300x300px)
- **Between sections:** Small accent leaves (50-100px) as dividers
- **Offerings grid:** Corner decorations on hover
- **Portal section:** Subtle vine border around edges

### Animation Behaviors
- Gentle float (2-3px movement, 4-6s durations)
- Slight rotation (-2° to 2°)
- Opacity pulse on hover (0.6 to 1.0)
- Stagger animation delays for natural feel

### Visual Style
- Line-art style (not filled)
- 1-2px stroke width
- Purple-600 color at 30% opacity
- SVG format for crispness

---

## DRAGONFLY ANIMATION DETAILS

### Idle State
- Subtle floating: 3px vertical, 8s duration, ease-in-out
- Very gentle scale pulse: 1.0 to 1.01, 10s duration

### Wing Hover States
- Hovered wing: opacity pulse (0.8 to 1.0, 1s)
- Subtle purple glow around wing (box-shadow: 0 0 20px purple-400)
- Other wings: slight opacity decrease (0.95)

### Click Animation
- Quick scale: 0.98 for 100ms, then back to 1.0
- Wing pulse on clicked wing
- Modal opening synchronized with wing highlight fading

---

## THIRD-PARTY INTEGRATIONS

### 1. Google Calendar
```javascript
// Embed Code Structure
<iframe 
  src="https://calendar.google.com/calendar/embed?src=YOUR_CALENDAR_ID&ctz=America/New_York"
  style="border: 0" 
  width="100%" 
  height="600" 
  frameborder="0" 
  scrolling="no">
</iframe>

// Custom Styling (inject via JS)
- Hide default Google branding where possible
- Override colors to match purple accent
- Adjust font sizes for consistency
```

### 2. Substack RSS Feed
```javascript
// Implementation Approach
const SUBSTACK_RSS = 'https://yoursubstack.substack.com/feed';

async function fetchSubstackPosts() {
  const cached = localStorage.getItem('substack_posts');
  const cacheTime = localStorage.getItem('substack_cache_time');
  
  if (cached && Date.now() - cacheTime < 3600000) {
    return JSON.parse(cached);
  }
  
  const response = await fetch(`https://api.rss2json.com/v1/api.json?rss_url=${SUBSTACK_RSS}`);
  const data = await response.json();
  
  localStorage.setItem('substack_posts', JSON.stringify(data.items.slice(0, 3)));
  localStorage.setItem('substack_cache_time', Date.now());
  
  return data.items.slice(0, 3);
}
```

### 3. Google Analytics
```javascript
// GA4 Implementation
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>

// Track Events
- Page load
- Wing clicks (with offering ID)
- Modal opens/closes
- Portal button click
- Social media clicks
- Substack post clicks
```

### 4. Interim Payment/Booking Solution
**Recommendation: Calendly + Stripe**

Option A - Calendly (Quick Setup):
- Embed Calendly widget for each offering
- Include pricing in Calendly descriptions
- Collect payment after booking confirmation
- Pros: Fast, professional, mobile-friendly
- Cons: Requires manual payment follow-up

Option B - Calendly + Stripe Payment Links (Better):
- Calendly for booking
- Stripe Payment Links for immediate payment
- Workflow: Book → Redirect to Stripe → Send confirmation
- Pros: Automated payment, professional
- Cons: Two-step process

Option C - Acuity Scheduling (Best Interim):
- Built-in payment processing via Stripe/Square
- One-step booking + payment
- Package/membership options for Seasonal Containers
- Customizable booking forms
- Email automation
- Pros: All-in-one, professional, ready for your custom solution later
- Cons: $16-45/month cost

**Recommendation: Go with Acuity Scheduling**
- Fastest professional solution
- Easy to replace with custom booking system later
- Clean API for future migration
- Embed code simple to integrate

### 5. Preparing for Future Custom Booking Engine
```javascript
// Code Architecture:
// Use booking-provider.js abstraction layer
// All booking calls go through this layer
// When custom engine ready, just swap provider

// Example:
// booking-provider.js
export const bookingProvider = {
  init: () => { /* Acuity setup */ },
  showBooking: (offeringId) => { /* Open Acuity */ },
  getUpcomingEvents: () => { /* Fetch from Acuity */ }
}

// Later swap to:
// booking-provider.js
export const bookingProvider = {
  init: () => { /* Custom API setup */ },
  showBooking: (offeringId) => { /* Open custom modal */ },
  getUpcomingEvents: () => { /* Fetch from custom DB */ }
}
```

---

## PERFORMANCE OPTIMIZATION

### Image Optimization
- Dragonfly PNG: Optimize to <200KB, use WebP with PNG fallback
- Botanical SVGs: Inline small ones, external file for larger
- Logo: SVG format, inline in HTML

### Loading Strategy
1. Critical CSS inline in `<head>`
2. Load fonts asynchronously
3. Defer non-critical scripts
4. Lazy load Substack posts (below fold)
5. Preload dragonfly image (above fold)

### Caching Strategy
- Static assets: 1 year cache
- HTML: No cache (for updates)
- Substack posts: 1 hour localStorage cache
- Calendar: No cache (always current)

---

## ACCESSIBILITY REQUIREMENTS

### Keyboard Navigation
- All clickable dragonfly wings: proper focus states
- Modal: trap focus, ESC to close
- Skip to main content link
- Logical tab order

### Screen Readers
- Semantic HTML (header, main, section, footer)
- ARIA labels on dragonfly hotspots
- Alt text: "Interactive dragonfly - click wings to explore offerings"
- Announce modal content changes

### Visual
- Color contrast: WCAG AAA for body text, AA for UI
- Focus indicators: 2px purple-600 ring
- No information conveyed by color alone

### Motion
- Respect prefers-reduced-motion media query
- Disable animations for users who prefer reduced motion
- Keep portal animation, but simplify (no swirl, quick fade)

---

## DEPLOYMENT CHECKLIST FOR HOSTGATOR

### Pre-Deployment
1. Convert React to vanilla JS + HTML
2. Bundle/minify CSS and JS
3. Optimize all images
4. Test on multiple browsers
5. Test on multiple devices/screen sizes
6. Verify all links work
7. Add meta tags (SEO, social)
8. Add favicon

### HostGator Setup
1. Upload files via FTP/cPanel File Manager
2. Set index.html as default document
3. Configure .htaccess for proper routing
4. Enable HTTPS (free SSL via HostGator)
5. Set up custom domain
6. Configure email if needed

### Post-Deployment
1. Verify Google Analytics tracking
2. Test Google Calendar embed
3. Test Substack RSS feed loading
4. Test payment/booking integration
5. Run Google PageSpeed Insights
6. Test portal animation across devices
7. Submit sitemap to Google Search Console

---

## CONTENT PLACEHOLDERS TO REPLACE

```javascript
// URLs to configure:
const CONFIG = {
  COACHING_SITE_URL: 'https://your-coaching-site.com',
  SUBSTACK_URL: 'https://yourname.substack.com',
  SUBSTACK_RSS: 'https://yourname.substack.com/feed',
  INSTAGRAM_HANDLE: '@yourhandle',
  FACEBOOK_URL: 'https://facebook.com/yourpage',
  GOOGLE_CALENDAR_ID: 'your-calendar-id@group.calendar.google.com',
  GOOGLE_ANALYTICS_ID: 'G-XXXXXXXXXX',
  BOOKING_URL: 'https://acuity.com/yourpage', // or custom
}
```

---

## BROWSER SUPPORT
- **Modern browsers:** Chrome, Firefox, Safari, Edge (last 2 versions)
- **Mobile:** iOS Safari 14+, Chrome Android 90+
- **Fallbacks:** Graceful degradation for animations
- **No support:** IE11 (2% market share, declining)

---

## SUCCESS METRICS TO TRACK

### User Engagement
- Time on page
- Scroll depth (how far users scroll)
- Wing click rate (which offerings get most clicks)
- Modal open → close rate (are people reading?)
- Portal button click rate
- Social media click rate

### Technical Performance
- Page load time (<3 seconds target)
- Time to Interactive (<4 seconds target)
- Cumulative Layout Shift (<0.1 target)
- First Contentful Paint (<1.5 seconds target)

### Conversion Goals
- Calendar event views
- Booking/payment completions
- Substack subscriptions (track via UTM)
- Portal transitions to coaching site

---

## PROJECT REQUIREMENTS SUMMARY

### Key User Flows
1. **Discovery Flow:** Land on page → Explore dragonfly wings → Learn about offerings → Book/contact
2. **Content Flow:** Read Substack posts → Subscribe → Engage with content
3. **Deep Dive Flow:** Ready for coaching → Portal animation → Coaching site
4. **Event Flow:** View calendar → Select event → Book/pay → Confirmation

### Critical Features
- Interactive dragonfly with 4 clickable wings
- Dynamic modal system with smooth animations
- Google Calendar auto-sync
- Substack RSS integration with caching
- Magical portal transition animation
- Responsive design (mobile-first)
- Booking/payment integration (Acuity interim)
- Google Analytics tracking
- Social media links

### Design Principles
- Clean, minimal aesthetic (white/black/purple)
- Nature-inspired elements (botanical illustrations)
- Smooth, delightful animations
- Professional yet welcoming
- Fast loading (<3s)
- Accessible (WCAG AA minimum)

---

## IMPLEMENTATION PHASES

### Phase 1: Core Structure (Week 1)
- HTML structure and semantic markup
- Design system setup (colors, typography, spacing)
- Header with logo
- Hero section
- Footer with social links
- Responsive grid system

### Phase 2: Interactive Dragonfly (Week 1-2)
- Dragonfly image integration
- Clickable hotspot positioning
- Modal overlay system
- Animation implementation
- Offering content cards
- Mobile touch optimization

### Phase 3: Calendar Integration (Week 2)
- Google Calendar embed
- Custom styling for calendar
- Auto-refresh mechanism
- Mobile responsiveness
- Placeholder for custom booking engine

### Phase 4: Content Integration (Week 2-3)
- Substack RSS feed setup
- Post card design
- Caching system
- Loading/error states
- Read more functionality

### Phase 5: Portal Animation (Week 3)
- Button interaction
- Canvas particle system
- SVG portal gradient
- Phase transitions
- Performance optimization
- Reduced motion support

### Phase 6: Polish & Optimization (Week 3-4)
- Botanical illustration placement
- Dragonfly idle animations
- Performance optimization
- Cross-browser testing
- Accessibility audit
- SEO optimization

### Phase 7: Third-Party Setup (Week 4)
- Google Analytics configuration
- Acuity Scheduling integration
- Social media verification
- Domain setup
- SSL certificate

### Phase 8: Deployment (Week 4)
- Build process setup
- HostGator upload
- DNS configuration
- Final testing
- Go live!

---

## NOTES FOR CLAUDE CODE

### Development Approach
- Start with mobile-first responsive design
- Build components modularly for easy maintenance
- Use CSS Grid and Flexbox for layouts
- Implement animations with CSS first, JS for complex interactions
- Keep code clean and well-commented
- Use semantic HTML for accessibility
- Test incrementally (don't wait until end)

### Common Pitfalls to Avoid
- Don't make hotspots too small on mobile
- Don't autoplay animations (respect reduced-motion)
- Don't forget focus states for keyboard navigation
- Don't hardcode breakpoints (use relative units)
- Don't block main thread with heavy JS
- Don't forget loading states for async content
- Don't ignore error handling for API calls

### Testing Checklist
- [ ] All wings clickable on mobile
- [ ] Modal closes on ESC key
- [ ] Modal closes on backdrop click
- [ ] Calendar loads and displays events
- [ ] Substack posts load with fallback
- [ ] Portal animation works smoothly
- [ ] Social links open correctly
- [ ] Analytics fires on all events
- [ ] Page loads fast (Lighthouse score >90)
- [ ] Works without JavaScript (graceful degradation)
- [ ] Screen reader announces content correctly
- [ ] Works in Safari, Chrome, Firefox, Edge

---

## ASSETS NEEDED

### Images
- [ ] Dragonfly logo (small wordmark for header)
- [ ] Main dragonfly PNG (already uploaded: IMG_2319.png)
- [ ] Wings + eye mystical graphic (already uploaded: IMG_2318.png)
- [ ] Botanical leaf illustrations (SVG, 3-5 variations)
- [ ] Favicon (16x16, 32x32, 180x180)

### Fonts
- [ ] Picnic Club font file (WOFF2 format)
- [ ] Backup web-safe font defined

### Content
- [ ] Offering descriptions (4 detailed paragraphs)
- [ ] Substack URL and RSS feed
- [ ] Instagram handle
- [ ] Facebook page URL
- [ ] Google Calendar ID
- [ ] Google Analytics ID
- [ ] Coaching site URL
- [ ] Copyright year and business name

---

## FINAL DELIVERABLES

1. Fully functional single-page website
2. Source code (HTML, CSS, JS)
3. Optimized assets folder
4. README with setup instructions
5. Configuration file for easy updates
6. Deployment guide for HostGator
7. Analytics setup documentation
8. Maintenance guide

---

**Ready to build something magical! 🦋✨**

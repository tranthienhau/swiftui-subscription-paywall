# Screenshot & Demo Regeneration

How the committed screenshots (`screenshots/01-*.png` ... `06-*.png`) and `screenshots/demo.gif`
were produced. The app exposes launch arguments so each screen can be driven deterministically
on the simulator - no manual tapping.

## Launch arguments

| Arg | Effect |
|---|---|
| `-screen welcome` | Onboarding / VSL intro (default) |
| `-screen paywall` | Hard paywall |
| `-screen main` | Main tabs (Library) |
| `-screen detail` | Push a content detail (add `-subscribed` for the unlocked state) |
| `-screen favorites` | Main tabs -> Favorites |
| `-screen settings` | Main tabs -> Settings |
| `-subscribed` | Start with an active entitlement |
| `-demo` | Auto-cycle every screen on a timer (used to record the GIF) |

## 1. Boot + build + install

```bash
xcrun simctl boot "iPhone 17 Pro"
xcrun simctl status_bar "iPhone 17 Pro" override --time "9:41" \
  --batteryLevel 100 --batteryState charged --cellularBars 4 --wifiBars 3

xcodegen generate
xcodebuild -project RadiantLife.xcodeproj -scheme RadiantLife \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -derivedDataPath build build
APP=$(find build/Build/Products -name "RadiantLife.app" | head -1)
xcrun simctl install "iPhone 17 Pro" "$APP"
```

## 2. Capture screenshots

`simctl launch` resumes a suspended app and ignores new launch args, so the app must be
fully terminated before each launch. Wait until it disappears from `launchctl list`:

```bash
ID=com.tranthienhau.radiantlife; DEV="iPhone 17 Pro"
shoot() {  # $1 = args, $2 = output file
  xcrun simctl terminate "$DEV" $ID 2>/dev/null
  while xcrun simctl spawn "$DEV" launchctl list | grep -q "$ID"; do sleep 0.5; done
  sleep 1
  xcrun simctl launch "$DEV" $ID $1
  sleep 4
  xcrun simctl io "$DEV" screenshot screenshots/$2
}
shoot "-screen welcome"            01-welcome.png
shoot "-screen paywall"            02-paywall.png
shoot "-screen main"               03-library.png
shoot "-screen detail -subscribed" 04-detail.png
shoot "-screen favorites"          05-favorites.png
shoot "-screen settings -subscribed" 06-settings.png
```

## 3. Record the demo GIF

`-demo` makes the app tour every screen with smooth transitions, so one continuous
recording stays clean (no springboard flashes):

```bash
xcrun simctl launch "iPhone 17 Pro" com.tranthienhau.radiantlife -demo
sleep 2
xcrun simctl io "iPhone 17 Pro" recordVideo --codec h264 --force /tmp/demo.mov &
REC=$!; sleep 16.5; kill -INT $REC

ffmpeg -y -i /tmp/demo.mov -vf "fps=12,scale=300:-1:flags=lanczos,palettegen=stats_mode=diff" /tmp/pal.png
ffmpeg -y -i /tmp/demo.mov -i /tmp/pal.png \
  -lavfi "fps=12,scale=300:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=3" \
  screenshots/demo.gif
```

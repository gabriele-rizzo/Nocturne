<img src="docs/icon.png" alt="Icon" width="180"/>

# Nocturne
### Your keyboard backlight, on a schedule.

Nocturne is a small menu bar app that turns the built-in keyboard backlight off when you don't need it: all day, on a schedule you set, or from sunrise to sunset wherever you are. It hands it back untouched when you're done.

[![Download](https://img.shields.io/badge/download-latest-brightgreen?style=flat-square)](https://github.com/gabriele-rizzo/Nocturne/releases/latest)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)
![Requirements](https://img.shields.io/badge/requirements-macOS%2015.7%2B-fa4e49?style=flat-square)
[![License](https://img.shields.io/badge/license-PolyForm%20Noncommercial-lightgrey?style=flat-square)](LICENSE)
<!-- [![Website](https://img.shields.io/badge/Website-015FBA?style=flat-square)](https://example.com) -->

> [!NOTE]
> Nocturne isn't notarized yet, so macOS will say the developer cannot be verified the first time you open it. See [Installation](#installation).

<a href="https://www.buymeacoffee.com/gabrielerizzo" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60" width="217"></a>

### Installation

Download the latest release, drag Nocturne into your Applications folder, and launch it. It lives in the menu bar and has no window and no Dock icon.

macOS will say the developer cannot be verified, because Nocturne isn't notarized yet. Right-click the app and choose **Open**, then confirm. You only need to do this once.

You can also build it yourself. See [Building](#building).

### Usage

Nocturne puts an icon in the right side of your menu bar. Click it to choose when the backlight should be off.

<img src="docs/menu-bar-icon.png" alt="The Nocturne icon in the menu bar" width="378"/>

There are four schedules:

- **Always on**: Nocturne stays out of the way and the backlight behaves normally.
- **Always off**: the backlight stays off.
- **Sunset to sunrise**: the backlight is off during daylight and comes back when it gets dark. Uses civil twilight, so it switches when it's actually dark rather than at the moment the sun crosses the horizon.
- **Custom**: pick the hours the backlight should be off.

<img src="docs/menu.png" alt="The Nocturne menu" width="250"/>

Custom schedules are set from the submenu, one hour for the start and one for the end. Windows that run past midnight are fine, so 22:00 to 07:00 works as you'd expect.

<img src="docs/custom-schedule.png" alt="The Custom submenu, with the From hour list open" width="385"/>

**Prevent Dimming** stops macOS from fading the keyboard backlight after a minute of inactivity. It's off by default, and Nocturne puts your original setting back when it quits.

**Launch at Login** starts Nocturne automatically. macOS may ask you to approve it in System Settings the first time.

Sunset to sunrise needs your location to work out when the sun rises and sets. Nocturne only ever computes times locally, and nothing is sent anywhere. Because it's a menu bar app, macOS may not show a permission prompt, so the menu offers a shortcut to the Location Services settings if it needs granting.

### Building

Requires macOS 15.7 or later and Xcode 26 or later.

```
git clone https://github.com/gabriele-rizzo/Nocturne.git
cd Nocturne
open Nocturne.xcodeproj
```

No signing setup is needed, because the project builds ad-hoc out of the box.

To sign with your own Apple developer team instead, create a `Local.xcconfig` next to the project:

```
DEVELOPMENT_TEAM = YOURTEAMID
CODE_SIGN_IDENTITY = Apple Development
```

It's gitignored, so it stays out of the repository.

Run the tests with:

```
xcodebuild test -project Nocturne.xcodeproj -scheme Nocturne -destination 'platform=macOS'
```

### FAQ

##### Does this drain or damage anything?

No. Nocturne only sets the keyboard backlight brightness, the same value the F5 and F6 keys change. Everything it touches is restored when it quits.

##### Why does the backlight come back on by itself sometimes?

macOS drives the keyboard backlight from the ambient light sensor and dims it after a minute of inactivity. While Nocturne is holding the backlight off it turns the ambient light sensor off so the two don't fight, and it turns it straight back on afterwards, so the backlight stays responsive to the room whenever it's allowed to be on.

##### Does it work with an external keyboard?

Nocturne targets the built-in keyboard. External keyboards manage their own backlight and aren't affected.

##### Why isn't it on the App Store?

Nocturne uses a private Apple framework to reach the keyboard backlight, because there's no public API for it. That rules out the App Store, and it also means a future macOS release could change the interface and break it. If Nocturne stops working after a system update, that's the likely cause, so please open an issue.

##### What happens if it crashes while the backlight is off?

It records what it changed, so the next launch puts your brightness, dim timer and ambient light setting back rather than leaving the keyboard dark.

### Translations

Nocturne is available in English and Italian. Translations live in `Nocturne/Localizable.xcstrings` and `Nocturne/InfoPlist.xcstrings`, which open as string catalogs in Xcode. Adding a language is a self-contained contribution: pick it in the catalog editor, fill in the values, and add the language code to the project's known regions.

### License

Nocturne is released under the [PolyForm Noncommercial License 1.0.0](LICENSE). You're free to use, modify and share it for any noncommercial purpose. Selling it, or using it as part of a commercial product or service, is not permitted.

# Change Log

## Unreleased (fork)

```diff
+ app:Notify(title, text, options?) — toast notifications (theme-aware; Duration, Position, Animate, Sound, SoundVolume)
+ app:ColorPicker(options?) — modal HSV color picker (Title, InitialColor, ValueChanged)
+ app:PlaySound(name, volume?) — built-in notification/UI sounds (registry: hl2 grab, tf2 warn, discord, etc.)
+ app:SoundNames() — returns list of available sound names for PlaySound / Notify
+ app:AddSound(name, assetId) — add custom sound to the list (e.g. app:AddSound("my noti", "rbxassetid://123"))
+ app:RemoveSound(name) — remove a sound (built-in or custom) by name
+ app:Watermark(options?) — corner watermark (Title, Body, Position, Enabled). Returns handle: Destroy(), SetBody(text), SetVisible(bool), SetPosition(pos)
+ PullDownButton: scrolling when many options (max height 240px, scrollbar)
```

## v1.0.1-beta.1 (12/2/2025)

```diff
+ Added warning if you call ':Window()' on the Cascade module instead of an Application for API conversion help.
+ Added `Maximum` property to `PopUpButton` (multi-select)

! Fixed section component returning type `Tab` instead of `Section`
! Slight visual changes to the push button component
```

## v1.0.0 (9/13/2025)

🥳 Officially released!

Thanks to those who used beta and reported bugs, everything is pretty bug-free.

```diff
+ Included .pcmp configuration in /pipeline, distribution key uses dotenv now

! Backend changes
! Changes and clarifications in installation docs
```

## v1.0.0-beta.7 (8/30/2025)

```diff
! Removed the `_P` PCMP build metadata global which was interfering with other builds that use PCMP. (It is now instead preserved in metadata tags.)
! Minor PR merge fixing spelling of "Luau"
```

## v1.0.0-beta.6 (7/19/2025)

```diff
! Fixed an issue where some first person games wouldn't let you move your camera around with a cascade window open. This was due to a modal frame.
! Fixed an issue where menus (pop-up menu, pull-down menu) would show behind the main window.
! Fixed an issue where the search field would not be visible at first.
```

## v1.0.0-beta.5 (7/17/2025)

```diff
+ Added pull-down buttons

! Fixed an issue where clicking off a menu (pull down buttons, pop up buttons) is offset around 30-40 pixels. This was fixed by counter-accounting for topbar inset.

? Possibly fixed an issue with the toggle's theme not using the correct theme on startup
```

## v1.0.0-beta.4 (7/15/2025)

```diff
+ Added pop-up buttons

- Removed a leftover print statement in symbols (Prints its style)

! Optimized toggles slightly by not putting them in a canvas groups, this should improve memory consumption.
! Changed the way a tab indent's itself, now instead of it's size being changed, the contents margins shrink to the right.
! Fixed unchanged statements in radio button groups (docs) from a copied component document in the docs.
! Fixed radio button groups having a default value if no value was given.
! Fixed accessory sizing behavior in rows (particularly the issue was for text fields, but this extends to all components.)
```

## v1.0.0-beta.3 (7/13/2025)

```diff
! Fixed errors on minimize if blur was disabled on startup.
! Fixed the search field not being set as non-visible if it was touching something on startup.

+ Added Auto-step when a stepper increment/decrement arrow is held.

? Possibly fixed an issue with the toggle's theme not using the correct theme on startup
```

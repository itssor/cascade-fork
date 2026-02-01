# App

You can create a new app by calling the `New` method from the Cascade API. This returns a custom object merged with a `ScreenGui`.

The returned object exposes all built-in [Components](../../Components/index.md) such as [Window](../../Components/Window.md), [Tab](../../Components/Tab.md), and others for UI composition.

## Summary

### Properties

| Property | Type | Description |
|--------|--------|--------|
| WindowPill | `boolean?` | Whether or not the window minimize/restore pill should be visible. |
| Theme | `Theme?` | Defines the color pallete used by the overall application. |

[View all inherited from ScreenGui](https://create.roblox.com/docs/reference/engine/classes/ScreenGui#summary-properties)

### Methods (app-level)

| Method | Description |
|--------|--------------|
| `app:Notify(title, text, options?)` | Show a toast notification. Options: `Duration`, `Position` (TopLeft/TopRight/BottomLeft/BottomRight/Center), `Animate`, `Sound`, `SoundVolume`. |
| `app:ColorPicker(options?)` | Open a modal color picker. Options: `Title`, `InitialColor`, `ValueChanged(color)`. |
| `app:PlaySound(name, volume?)` | Play a built-in sound by name (e.g. `"tf2 menu"`, `"discord"`). Returns `boolean`. |
| `app:SoundNames()` | Returns an array of available sound names for `PlaySound` or Notify `Sound` option. |
| `app:AddSound(name, assetId)` | Add a custom sound (e.g. `app:AddSound("my noti", "rbxassetid://123")`). |
| `app:RemoveSound(name)` | Remove a sound (built-in or custom) by name. |
| `app:Watermark(options?)` | Show a corner watermark. Options: `Title`, `Body`, `Position` (TopLeft/TopRight/BottomLeft/BottomRight), `Enabled`. Returns a handle with `Destroy()`, `SetBody(text)`, `SetVisible(bool)`, `SetPosition(pos)` so you can update FPS/ping etc. |

[View all inherited from ScreenGui](https://create.roblox.com/docs/reference/engine/classes/ScreenGui#summary-methods)

### Events

[View all inherited from ScreenGui](https://create.roblox.com/docs/reference/engine/classes/ScreenGui#summary-events)

## Types

```luau
type AppProperties = ScreenGui & {
    WindowPill: boolean?,
    Theme: Theme?,
}

type App = AppProperties & Components
```

### Function Signature

```luau
function(self, properties: AppProperties): App
```

## Example

```luau linenums="1"
local app = cascade.New({
    WindowPill = true,
    Theme = cascade.Themes.Light
})
```

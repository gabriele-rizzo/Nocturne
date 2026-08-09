cask "nocturne" do
  version "1.2.0"
  sha256 "c54f059475805a482ee41e69f576c7241a8fbe4c83c05af6d2850bbe11ceebc7"

  url "https://github.com/gabriele-rizzo/Nocturne/releases/download/v#{version}/Nocturne.dmg",
      verified: "github.com/gabriele-rizzo/Nocturne/"
  name "Nocturne"
  desc "Turns the built-in keyboard backlight off on a schedule"
  homepage "https://github.com/gabriele-rizzo/Nocturne"

  auto_updates true
  depends_on macos: :sequoia

  app "Nocturne.app"

  zap trash: "~/Library/Preferences/gabrielerizzo.Nocturne.plist"
end

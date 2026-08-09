cask "nocturne" do
  version "1.2.2"
  sha256 "4f0554fe2fc7be89902ad18f767b5bb9815cad7246bc6b425888215109f0b22d"

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

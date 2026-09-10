-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Logitech: tray baterai mouse (G304) + GUI/tray headset (G733)
o.launch_on_start("solaar --window=hide")
o.launch_on_start("headsetkontrol")

-- Cold boot: touchpad I2C (SYNA2BA6) kadang baru selesai enumerate SETELAH
-- Hyprland parse config, jadi disable dari omarchy toggle (device{enabled=false})
-- kelewat. Reload sekali setelah device settle biar disabled-input-device.lua
-- jalan lagi dengan device sudah ada.
o.launch_on_start("bash -c 'sleep 4; hyprctl reload'")

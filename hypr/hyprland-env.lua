local home = assert(os.getenv("HOME"), "HOME is not set")

local environment = {
    LIBVA_DRIVER_NAME = "nvidia",
    XDG_CURRENT_DESKTOP = "Hyprland",
    XDG_SESSION_DESKTOP = "Hyprland",
    XDG_SESSION_TYPE = "wayland",
    GBM_BACKEND = "nvidia-drm",
    __GLX_VENDOR_LIBRARY_NAME = "nvidia",
    WLR_RENDERER_ALLOW_SOFTWARE = "1",
    WLR_DRM_NO_ATOMIC = "1",
    HYPRSHOT_DIR = "Pictures/Screenshots",
    XCURSOR_SIZE = "24",
    QT_QPA_PLATFORMTHEME = "qt5ct",
    XDG_CONFIG_HOME = home .. "/.config",
}

for name, value in pairs(environment) do
    hl.env(name, value)
end

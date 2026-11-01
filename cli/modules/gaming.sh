#!/usr/bin/env bash
# ==============================================================================
# Pars Linux - Gaming Modülü (pars-gaming)
# Bileşenler: Steam, Lutris, Heroic, GameMode, MangoHud
# ==============================================================================

ROLE_GAMING_NAME="pars-gaming"
ROLE_GAMING_DESC="Steam, Lutris, Heroic Launcher, GameMode, MangoHud"

# Alt bileşenler listesi: ID:Ad:VarsayılanSeçili (1/0)
GAMING_COMPONENTS=(
    "steam:Steam İstemcisi:1"
    "lutris:Lutris Oyun Yöneticisi:1"
    "heroic:Heroic Games Launcher (Epic/GOG):1"
    "gamemode:Feral GameMode Optimizatör:1"
    "mangohud:MangoHud FPS/Donanım Katmanı:1"
)

install_gaming_steam() {
    log_info "Steam kuruluyor..."
    local pm
    pm="$(detect_package_manager)"
    case "${pm}" in
        pacman) pkg_install "steam" "com.valvesoftware.Steam" ;;
        apt)    pkg_install "steam-installer" "com.valvesoftware.Steam" ;;
        *)      pkg_install "steam" "com.valvesoftware.Steam" ;;
    esac
}

install_gaming_lutris() {
    log_info "Lutris kuruluyor..."
    pkg_install "lutris" "net.lutris.Lutris"
}

install_gaming_heroic() {
    log_info "Heroic Games Launcher kuruluyor..."
    local pm
    pm="$(detect_package_manager)"
    case "${pm}" in
        pacman) pkg_install "heroic-games-launcher-bin" "com.heroicgameslauncher.hgl" ;;
        *)      pkg_install "heroic" "com.heroicgameslauncher.hgl" ;;
    esac
}

install_gaming_gamemode() {
    log_info "GameMode ve servis optimizasyonları kuruluyor..."
    pkg_install "gamemode" ""
    # Servisi etkinleştir (varsa)
    systemctl --user enable --now gamemoded.service 2>/dev/null || true
    log_success "GameMode servisi etkinleştirildi."
}

install_gaming_mangohud() {
    log_info "MangoHud katmanı kuruluyor..."
    pkg_install "mangohud" ""
}

install_gaming_all() {
    log_header "pars-gaming Rolü Kurulumu Başlatılıyor"
    install_gaming_gamemode
    install_gaming_mangohud
    install_gaming_steam
    install_gaming_lutris
    install_gaming_heroic
    log_success "pars-gaming kurulumu tamamlandı!"
}

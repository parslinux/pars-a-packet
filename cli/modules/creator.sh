#!/usr/bin/env bash
# ==============================================================================
# Pars Linux - İçerik Üretici Modülü (pars-creator)
# Bileşenler: OBS Studio, GIMP, Inkscape, Kdenlive, Audacity
# ==============================================================================

ROLE_CREATOR_NAME="pars-creator"
ROLE_CREATOR_DESC="OBS Studio, GIMP, Inkscape, Kdenlive, Audacity"

# Alt bileşenler listesi: ID:Ad:VarsayılanSeçili (1/0)
CREATOR_COMPONENTS=(
    "obs:OBS Studio Ekran Kaydı & Canlı Yayın:1"
    "gimp:GIMP Raster Grafik & Fotoğraf Düzenleme:1"
    "inkscape:Inkscape Vektörel Tasarım (SVG):1"
    "kdenlive:Kdenlive Doğrusal Olmayan Video Düzenleme:1"
    "audacity:Audacity Çok Kanallı Ses Düzenleyici:1"
)

install_creator_obs() {
    log_info "OBS Studio kuruluyor..."
    pkg_install "obs-studio" "com.obsproject.Studio"
}

install_creator_gimp() {
    log_info "GIMP kuruluyor..."
    pkg_install "gimp" "org.gimp.GIMP"
}

install_creator_inkscape() {
    log_info "Inkscape kuruluyor..."
    pkg_install "inkscape" "org.inkscape.Inkscape"
}

install_creator_kdenlive() {
    log_info "Kdenlive kuruluyor..."
    pkg_install "kdenlive" "org.kde.kdenlive"
}

install_creator_audacity() {
    log_info "Audacity kuruluyor..."
    pkg_install "audacity" "org.audacityteam.Audacity"
}

install_creator_all() {
    log_header "pars-creator Rolü Kurulumu Başlatılıyor"
    install_creator_obs
    install_creator_gimp
    install_creator_inkscape
    install_creator_kdenlive
    install_creator_audacity
    log_success "pars-creator kurulumu tamamlandı!"
}

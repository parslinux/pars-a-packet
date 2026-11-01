# 🚀 Pars Linux - Ek Paket Rolleri Gelişim & İlerleme Raporu (progress.md)

Bu belge, **Pars Linux Modüler Ek Paket Rolleri (Meta Paketler)** projesinin tamamlanan adımlarını, mevcut durumunu ve gelecek yol haritasını takip etmek için tutulmaktadır.

Son Güncelleme: 2026-10-20

---

## 📊 Genel Durum Özeti

| Kategori | Durum | Açıklama |
|---|:---:|---|
| **`pars-gaming`** | ✅ Tamamlandı | Steam, Lutris, Heroic, GameMode, MangoHud modülleri hazır |
| **`pars-dev`** | ✅ Tamamlandı | Git, VS Codium, Docker, DBeaver modülleri hazır |
| **`pars-creator`** | ✅ Tamamlandı | OBS Studio, GIMP, Inkscape, Kdenlive, Audacity modülleri hazır |
| **Debian (.deb) Desteği** | ✅ Tamamlandı | 17 adet granüler + ana paket kontrol şablonu & derleyici |
| **Arch Linux Split PKGBUILD** | ✅ Tamamlandı | 3 split PKGBUILD & makepkg otomatik derleme betiği |
| **Modüler CLI / TUI Yükleyici** | ✅ Tamamlandı | pacman/apt/flatpak algılama, checklist TUI & parametrik CLI |
| **Profil Sistemi** | ✅ Tamamlandı | `gaming.conf`, `dev.conf`, `creator.conf` profilleri |

---

## 🛠️ Tamamlanan Görevler

### 1. 🎮 `pars-gaming` Rolü
- [x] Üst meta paket tanımlaması (`pars-gaming`)
- [x] `pars-gaming-steam`: Steam kurulumu ve donanım/udev gereksinimleri
- [x] `pars-gaming-lutris`: Lutris ve Wine ekosistemi
- [x] `pars-gaming-heroic`: Epic/GOG/Amazon desteği için Heroic Launcher (Native/Flatpak)
- [x] `pars-gaming-gamemode`: Feral GameMode servis optimizasyonları ve systemd user servisi
- [x] `pars-gaming-mangohud`: Vulkan/OpenGL oyun içi HUD göstergesi

### 2. 💻 `pars-dev` Rolü
- [x] Üst meta paket tanımlaması (`pars-dev`)
- [x] `pars-dev-git`: Git ve Git-LFS kurulumu, LFS küresel aktifleştirmesi
- [x] `pars-dev-codium`: Telemetrisiz açık kaynaklı VS Codium
- [x] `pars-dev-docker`: Docker Engine, Compose ve `docker` kullanıcı grubu postinst otomasyonu
- [x] `pars-dev-dbeaver`: Evrensel SQL veritabanı istemcisi (DBeaver CE)

### 3. 🎨 `pars-creator` Rolü
- [x] Üst meta paket tanımlaması (`pars-creator`)
- [x] `pars-creator-obs`: OBS Studio ekran kaydı, yayın ve sanal kamera desteği
- [x] `pars-creator-gimp`: GIMP raster görsel işleme
- [x] `pars-creator-inkscape`: Inkscape SVG vektör tasarımı
- [x] `pars-creator-kdenlive`: Kdenlive doğrusal olmayan video montajı
- [x] `pars-creator-audacity`: Audacity çok kanallı ses düzenleme aracı

### 4. 📦 Paketleme ve Derleme Altyapısı
- [x] `debian/build-deb.sh`: dpkg-deb mevcutsa yerel araçla, değilse saf `ar` + `tar` ile taşınabilir .deb üretimi
- [x] `arch/build-arch.sh`: Split paket yapısında makepkg entegrasyonu ve `.pkg.tar.zst` üretimi
- [x] Tüm paketlerin yerel ortamda başarılı derleme testleri

### 5. 🖥️ Modüler CLI ve TUI Kurulum Aracı
- [x] Paket yöneticisi otomatik tespiti (`pacman`, `apt`, `dnf`, `zypper`, `flatpak`)
- [x] Whiptail / Dialog destekli interaktif TUI Checklist menüsü
- [x] Fallback ANSI renkli konsol menüsü
- [x] `--list`, `--role`, `--modules`, `--profile`, `--interactive` komut satırı argümanları

---

## 🎯 Sıradaki Adımlar ve Yol Haritası

- [ ] **Calamares Entegrasyonu**: Pars Linux Calamares yükleyicisinin netinstall modülüne bu rollerin JSON/YAML tanımlarının eklenmesi.
- [ ] **Kullanıcı İzinleri & Yapılandırma TUI**: Kurulum sonrası kullanıcıya doğrudan Docker grubu, Flatpak flathub deposu veya MangoHud ön ayarlarını yaptıran sihirbaz.
- [ ] **Otomasyon & CI/CD**: GitHub Actions / GitLab CI üzerinde commit bazlı otomatik .deb ve .pkg.tar.zst derlenmesi ve depoya (APT / Pacman repo) gönderimi.

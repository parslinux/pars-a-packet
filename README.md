# 🎮 Pars Linux - Modüler Ek Paket Rolleri (Meta Paketler)

Pars Linux için tasarlanmış **modüler**, **granüler** ve **çoklu dağıtım uyumlu** ek paket rolleri sistemi.

Bu depo, kullanıcılara ve sistem kurucusuna (Calamares/TUI) aşağıdaki 3 ana rolü ve bu rollerin bağımsız alt bileşenlerini modüler olarak kurma imkânı sunar:

---

## 📦 Paket Rolleri ve Granüler Modüller

### 1. 🎮 `pars-gaming` (Oyun Rolü)
Oyun meraklıları ve e-spor oyuncuları için optimize edilmiş eksiksiz oyun ekosistemi.
* **`pars-gaming-gamemode`**: Feral Interactive GameMode CPU/GPU/I/O optimizasyon servisi.
* **`pars-gaming-mangohud`**: Oyun içi FPS, sıcaklık, VRAM, RAM ve kare zamanlaması HUD katmanı.
* **`pars-gaming-steam`**: Valve Steam oyun platformu ve kontrolcü udev kuralları.
* **`pars-gaming-lutris`**: Açık kaynaklı oyun yöneticisi (GOG, WINE, emülatörler).
* **`pars-gaming-heroic`**: Epic Games, GOG ve Amazon Prime oyunları için Heroic Games Launcher.

---

### 2. 💻 `pars-dev` (Geliştirici Rolü)
Modern yazılım geliştiricileri, DevOps ve veri mühendisleri için optimize edilmiş ortam.
* **`pars-dev-git`**: Git versiyon kontrolü ve Git Large File Storage (Git-LFS).
* **`pars-dev-codium`**: Telemetrisiz, tamamen açık kaynaklı VS Code ikilisi (VSCodium).
* **`pars-dev-docker`**: Docker Engine, Docker Compose servisi ve otomatik grup yapılandırması.
* **`pars-dev-dbeaver`**: Evrensel veritabanı yönetim arayüzü (PostgreSQL, MySQL, SQLite vb.).

---

### 3. 🎨 `pars-creator` (İçerik Üretici Rolü)
Yayıncılar, grafik tasarımcılar, video ve ses prodüktörleri için medya üretim istasyonu.
* **`pars-creator-obs`**: OBS Studio canlı yayın ve ekran kayıt yazılımı.
* **`pars-creator-gimp`**: GNU İmaj Düzenleyici (raster grafik ve fotoğraf rötuş).
* **`pars-creator-inkscape`**: Profesyonel vektörel grafik tasarım (SVG) aracı.
* **`pars-creator-kdenlive`**: MLT tabanlı çok kanallı profesyonel doğrusal olmayan video montaj yazılımı.
* **`pars-creator-audacity`**: Çok izli profesyonel ses düzenleme ve miksaj programı.

---

## 📂 Proje Dizin Yapısı

```
Ek_Paket_Rolleri/
├── debian/                         # Debian / Ubuntu / Pars (.deb) Meta Paketleri
│   ├── build-deb.sh                # .deb paketlerini derleme betiği (dpkg-deb & ar/tar desteği)
│   ├── dist/                       # Derlenmiş hazır .deb paketleri
│   ├── pars-gaming/                # Gaming ana ve alt .control dosyaları
│   ├── pars-dev/                   # Dev ana ve alt .control + postinst dosyaları
│   └── pars-creator/               # Creator ana ve alt .control dosyaları
├── arch/                           # Arch Linux / Pacman (.pkg.tar.zst) Paketleri
│   ├── build-arch.sh               # makepkg ile split paket derleme betiği
│   ├── dist/                       # Derlenmiş hazır .pkg.tar.zst paketleri
│   ├── pars-gaming/PKGBUILD        # Split PKGBUILD (gaming + 5 alt paket)
│   ├── pars-dev/PKGBUILD           # Split PKGBUILD (dev + 4 alt paket)
│   └── pars-creator/PKGBUILD       # Split PKGBUILD (creator + 5 alt paket)
├── cli/                            # Evrensel Modüler CLI & TUI Yükleyici
│   ├── pars-pkg-installer.sh       # Ana CLI/TUI aracı (checklist & console menü)
│   ├── modules/
│   │   ├── common.sh               # Paket yöneticisi algılama (pacman, apt, flatpak vb.)
│   │   ├── gaming.sh               # Gaming modülleri kurulum mantığı
│   │   ├── dev.sh                  # Dev modülleri kurulum mantığı
│   │   └── creator.sh              # Creator modülleri kurulum mantığı
│   └── profiles/
│       ├── gaming.conf             # Oyun profili bayrakları
│       ├── dev.conf                # Geliştirici profili bayrakları
│       └── creator.conf            # İçerik üretici profili bayrakları
└── README.md                       # Bu kılavuz
```

---

## 🚀 Kullanım Yöntemleri

### 1. Evrensel CLI & TUI Yükleyicisi (Önerilen)

Sisteminize göre (Arch/CachyOS, Debian/Ubuntu, Fedora vb.) paket yöneticisini otomatik algılar.

#### Modülleri Listeleme:
```bash
./cli/pars-pkg-installer.sh --list
```

#### İnteraktif TUI (Whiptail/Dialog Checklist veya Konsol Menüsü):
```bash
./cli/pars-pkg-installer.sh --interactive
# veya doğrudan argümansız:
./cli/pars-pkg-installer.sh
```

#### Belirli Bir Rolün Tamamını Kurma:
```bash
./cli/pars-pkg-installer.sh --role gaming
./cli/pars-pkg-installer.sh --role dev
./cli/pars-pkg-installer.sh --role creator
./cli/pars-pkg-installer.sh --role all
```

#### Granüler / Modüler Seçim ile Kurulum:
Sadece istediğiniz araçları virgülle ayırarak kurabilirsiniz:
```bash
./cli/pars-pkg-installer.sh --modules steam,lutris,docker,codium
```

#### Hazır Profil ile Kurulum:
```bash
./cli/pars-pkg-installer.sh --profile cli/profiles/gaming.conf
```

---

### 2. Debian Meta Paketlerini Derleme ve Kurma

Tüm `.deb` paketlerini derlemek için:
```bash
cd debian
bash build-deb.sh
```
Çıktılar `debian/dist/` klasörüne toplanır. Kurmak için:
```bash
# Tüm oyun rolünü kurmak:
sudo dpkg -i debian/dist/pars-gaming*.deb
sudo apt-get install -f   # Bağımlılıkları tamamlar

# Veya sadece Steam modülünü kurmak:
sudo dpkg -i debian/dist/pars-gaming-steam*.deb
sudo apt-get install -f
```

---

### 3. Arch Linux Paketlerini Derleme ve Kurma

Split PKGBUILD paketlerini derlemek için:
```bash
cd arch
bash build-arch.sh
```
Çıktılar `arch/dist/` klasörüne toplanır. Kurmak için:
```bash
# Tüm dev rolünü kurmak:
sudo pacman -U arch/dist/pars-dev*.pkg.tar.zst

# Veya sadece tek bir modülü kurmak:
sudo pacman -U arch/dist/pars-gaming-gamemode-*.pkg.tar.zst
```

---

## 🧩 Modülerlik Felsefesi

* **Üst Meta Paketler (`pars-gaming`, `pars-dev`, `pars-creator`)**: İlgili alanın temel bileşenlerini doğrudan bağımlılık (`Depends`), opsiyonel olanları ise tavsiye (`Recommends` / `optdepends`) olarak tanımlar.
* **Granüler Alt Modüller (`pars-gaming-steam`, `pars-dev-docker` vb.)**: Kullanıcı tüm rolü yüklemek istemediğinde sadece ihtiyaç duyduğu bileşeni bağımsız bir meta paket olarak kurabilir.
* **Hibrit Yedekleme**: Sistem yerel depolarında bulunmayan yazılımlar (örneğin bazı dağıtımlarda VSCodium veya Heroic) CLI yükleyici tarafından otomatik olarak güvenli Flathub/Flatpak depolarına yönlendirilir.

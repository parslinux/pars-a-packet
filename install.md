# 📖 Pars Linux - Ek Paket Rolleri Kurulum Kılavuzu (install.md)

Bu belge, **Pars Linux Modüler Ek Paket Rolleri**'nin farklı dağıtımlarda ve ortamlarda nasıl kurulacağını, derleneceğini ve yapılandırılacağını adım adım açıklamaktadır.

---

## 📋 Ön Gereksinimler

Sisteminizde aşağıdaki temel araçların bulunması önerilir:
* **Bash**: Sürüm 4.0 veya üzeri
* **Yetki**: `sudo` veya `root` yetkisi (paketleri sisteme kurmak için)
* **İsteğe Bağlı (TUI için)**: `whiptail` veya `dialog` (Checkbox grafik menü için)
* **İsteğe Bağlı (Flatpak yedekleme için)**: `flatpak` kurulu olması önerilir

---

## 🚀 1. Yöntem: Evrensel CLI & TUI Yükleyicisi (Önerilen)

En kolay ve esnek yöntemdir. Paket yöneticinizi (`pacman`, `apt`, `dnf` vb.) otomatik algılar.

### Adım 1: Çalıştırma İzni Verin
```bash
chmod +x cli/pars-pkg-installer.sh
```

### Adım 2: Mevcut Rolleri İnceleyin
```bash
./cli/pars-pkg-installer.sh --list
```

### Adım 3: Kurulum Seçenekleri

#### A) İnteraktif TUI (Görsel Seçim Menüsü)
Ekranda açılan menüden **Boşluk (Space)** tuşuyla istediğiniz uygulamaları seçip **Enter** ile kurabilirsiniz:
```bash
./cli/pars-pkg-installer.sh --interactive
# veya doğrudan argümansız:
./cli/pars-pkg-installer.sh
```

#### B) Tek Bir Rolün Tamamını Kurma
```bash
# Tüm oyun ortamını kurar (Steam, Lutris, Heroic, GameMode, MangoHud)
./cli/pars-pkg-installer.sh --role gaming

# Tüm geliştirici ortamını kurar (Git, Codium, Docker, DBeaver)
./cli/pars-pkg-installer.sh --role dev

# Tüm içerik üretici ortamını kurar (OBS, GIMP, Inkscape, Kdenlive, Audacity)
./cli/pars-pkg-installer.sh --role creator

# Bütün rolleri tek seferde kurar
./cli/pars-pkg-installer.sh --role all
```

#### C) Granüler / Modüler Kurulum (İstediğin Modülleri Seç)
Sadece ihtiyaç duyduğunuz bileşenleri virgülle ayırarak belirtebilirsiniz:
```bash
# Sadece Steam, Codium ve Docker kurmak için:
./cli/pars-pkg-installer.sh --modules steam,codium,docker

# Sadece OBS ve Audacity kurmak için:
./cli/pars-pkg-installer.sh --modules obs,audacity
```

#### D) Hazır Profil Dosyasıyla Kurulum
Önceden tanımlanmış konfigürasyon profillerini uygulayabilirsiniz:
```bash
./cli/pars-pkg-installer.sh --profile cli/profiles/gaming.conf
./cli/pars-pkg-installer.sh --profile cli/profiles/dev.conf
./cli/pars-pkg-installer.sh --profile cli/profiles/creator.conf
```

---

## 🐧 2. Yöntem: Debian (.deb) Meta Paketleri ile Kurulum

Debian, Ubuntu veya Pars Linux (.deb tabanlı) sistemlerde yerel meta paketleri kullanabilirsiniz.

### Adım 1: Paketleri Derleyin
```bash
cd debian
bash build-deb.sh
```
Derlenen paketler `debian/dist/` klasörüne kaydedilir.

### Adım 2: Paketleri Sisteme Kurun

#### A) Rolün Tamamını Kurmak:
```bash
# Örnek: Oyun rolü
sudo dpkg -i debian/dist/pars-gaming*.deb
sudo apt-get install -f -y   # Eksik bağımlılıkları depolarından çeker
```

#### B) Sadece Tek Bir Modülü Kurmak:
```bash
# Sadece Steam modülü
sudo dpkg -i debian/dist/pars-gaming-steam_1.0.0_all.deb
sudo apt-get install -f -y

# Sadece Docker modülü
sudo dpkg -i debian/dist/pars-dev-docker_1.0.0_all.deb
sudo apt-get install -f -y
```

---

## 🏹 3. Yöntem: Arch Linux (.pkg.tar.zst) Paketleri ile Kurulum

Arch Linux, CachyOS, Manjaro veya Pars Linux (Arch tabanlı) sistemlerde Pacman ile kurulum.

### Adım 1: Split Paketleri Derleyin
```bash
cd arch
bash build-arch.sh
```
Derlenen tüm paketler `arch/dist/` içerisine toplanır.

### Adım 2: Pacman ile Yükleyin

#### A) Rolün Tamamını Kurmak:
```bash
sudo pacman -U --needed arch/dist/pars-gaming*.pkg.tar.zst
```

#### B) Granüler Olarak Tek Modül Kurmak:
```bash
# Sadece MangoHud
sudo pacman -U --needed arch/dist/pars-gaming-mangohud-1.0.0-1-any.pkg.tar.zst

# Sadece VSCodium
sudo pacman -U --needed arch/dist/pars-dev-codium-1.0.0-1-any.pkg.tar.zst
```

---

## ⚙️ Kurulum Sonrası Yapılandırmalar ve İpuçları

### 1. Docker Kullanıcı İzni (Sudo Olmadan Docker Çalıştırma)
`pars-dev-docker` kurulduktan sonra kullanıcınızın `docker` grubuna eklenmesi gerekir:
```bash
sudo usermod -aG docker $USER
# Değişikliğin geçerli olması için oturumu kapatıp açın veya:
newgrp docker
```
Docker servisini kontrol etmek için:
```bash
sudo systemctl status docker.service
```

### 2. GameMode Servisi
`pars-gaming-gamemode` kurulduktan sonra kullanıcı seviyesinde çalışır:
```bash
systemctl --user enable --now gamemoded.service
# Durum kontrolü:
gamemoded -s
```

### 3. Steam & MangoHud Entegrasyonu
Steam oyunlarında MangoHud'ı aktif etmek için oyunun başlatma seçeneklerine (Launch Options) şunu ekleyin:
```bash
mangohud %command%
```
GameMode ile birlikte çalıştırmak için:
```bash
gamemoderun mangohud %command%
```

---

## ❓ Sorun Giderme (FAQ)

**S: Bir paket yerel depolarda bulunamadı uyarısı veriyor, ne yapmalıyım?**  
C: CLI yükleyici (`pars-pkg-installer.sh`), sistem depolarında bulunamayan yazılımlar (VSCodium, Heroic vb.) için otomatik olarak Flatpak / Flathub desteğini kullanır. Sisteminizde `flatpak` kurulu olduğundan emin olun.

**S: Whiptail/dialog menüsü yerine metin konsolu açılıyor, neden?**  
C: Sisteminizde `whiptail` veya `dialog` paketi yüklü olmadığında betik güvenli bir şekilde metin tabanlı konsol menüsüne geçer. Görsel menü için:
* Arch: `sudo pacman -S libnewt` (whiptail içerir)
* Debian/Ubuntu: `sudo apt install whiptail`

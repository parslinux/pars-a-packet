# 🤖 Pars Linux - Ek Paket Rolleri Yapay Zeka & Geliştirici Kılavuzu (claude.md)

Bu belge, Claude ve diğer yapay zeka ajanlarının bu depoda kod yazarken, düzenleme yaparken veya yeni modüller eklerken uyması gereken **mimari prensipleri**, **standartları** ve **çalışma kurallarını** tanımlar.

---

## 🎯 Projenin Temel Felsefesi

1. **Modülerlik ve Granülerlik Esastır:**  
   Kullanıcı asla tüm rolü kurmaya zorlanmamalıdır. Üst meta paketler (`pars-gaming`, `pars-dev`, `pars-creator`) şemsiye görevi görürken, her alt bileşen (`pars-gaming-steam`, `pars-dev-docker` vb.) bağımsız kurulabilir olmalıdır.
2. **Çoklu Dağıtım Uyumluluğu (Multi-Distro):**  
   Hem Debian/Ubuntu tabanlı (`.deb`), hem Arch Linux tabanlı (`PKGBUILD` / `.pkg.tar.zst`), hem de evrensel Bash/Flatpak CLI yükleyicisi eş zamanlı güncel tutulmalıdır.
3. **Maksimum Taşınabilirlik (Portability):**  
   Harici araçlara minimum bağımlılık. Örneğin `build-deb.sh` betiği sistemde `dpkg-deb` olmadığında bile saf `ar` + `tar` ile geçerli `.deb` oluşturabilecek esneklikte kalmalıdır.

---

## 📂 Dizin Standartları

```
Ek_Paket_Rolleri/
├── debian/                     # Debian meta paket şablonları
│   ├── build-deb.sh            # Tüm *.control dosyalarını derleyen betik
│   ├── dist/                   # .deb çıktıları (git/claudeignore altında)
│   ├── pars-gaming/            # Gaming .control dosyaları
│   ├── pars-dev/               # Dev .control + *.postinst dosyaları
│   └── pars-creator/           # Creator .control dosyaları
├── arch/                       # Arch Linux paket tanımları
│   ├── build-arch.sh           # makepkg ile split paket derleyici
│   ├── dist/                   # .pkg.tar.zst çıktıları (git/claudeignore altında)
│   └── pars-*/PKGBUILD         # Split paket PKGBUILD dosyaları
├── cli/                        # Evrensel modüler yükleyici
│   ├── pars-pkg-installer.sh   # Ana çalıştırma betiği & menü/argüman kontrolü
│   ├── modules/                # Rol bazlı shell modülleri (gaming.sh, dev.sh, creator.sh)
│   └── profiles/               # Açma/kapama konfigürasyon profilleri (*.conf)
├── README.md                   # Kullanıcı genel dokümantasyonu
├── install.md                  # Ayrıntılı kurulum yönergeleri
├── progress.md                 # Yapılan işler ve ilerleme takibi
├── claude.md                   # Bu rehber
└── .claudeignore               # Yapay zeka dosya tarama hariç tutma kuralları
```

---

## ➕ Yeni Bir Modül veya Rol Eklerken İzlenecek Adımlar

Yeni bir bileşen (örneğin `pars-gaming` altına `heroic` gibi yeni bir alt araç veya `pars-office` gibi yeni bir rol) eklendiğinde **aşağıdaki 6 adım eksiksiz tamamlanmalıdır**:

### 1. Debian Tarafı (`debian/`)
- İlgili klasör altında `pars-<rol>-<modül>.control` dosyasını oluşturun.
- Gerekirse paket sonrası yapılandırma için `pars-<rol>-<modül>.postinst` dosyasını ekleyin (`chmod 755`).
- Ana meta paketin (`pars-<rol>.control`) `Recommends` veya `Depends` satırına yeni alt paketi ekleyin.

### 2. Arch Linux Tarafı (`arch/`)
- `arch/pars-<rol>/PKGBUILD` dosyasındaki `pkgname=( ... )` dizisine yeni alt paketi ekleyin.
- `package_pars-<rol>-<modül>()` fonksiyonunu tanımlayın.
- Ana rolün `package_pars-<rol>()` fonksiyonundaki `optdepends` listesini güncelleyin.

### 3. CLI Modülü (`cli/modules/`)
- `cli/modules/<rol>.sh` dosyasındaki `<ROL>_COMPONENTS` dizisine `"modul_id:Görünen Ad:1"` formatında ekleyin.
- `install_<rol>_<modül>()` fonksiyonunu yazın (yerel paket adı + Flatpak AppID fallback desteği ile `pkg_install`).
- `install_<rol>_all()` fonksiyonuna çağrısını ekleyin.

### 4. CLI Yükleyici Ana Eşleme (`cli/pars-pkg-installer.sh`)
- `install_by_id()` içerisindeki `case` bloğuna yeni `modul_id` karşılığını ekleyin.
- `run_from_profile()` fonksiyonuna profil kontrolünü (`[[ "${ENABLE_<MODUL>:-0}" == "1" ]]`) ekleyin.

### 5. Profil Dosyaları (`cli/profiles/`)
- `cli/profiles/<rol>.conf` içerisine `ENABLE_<MODUL>=1` bayrağını ekleyin.

### 6. Dokümantasyon
- `README.md`, `install.md` ve `progress.md` dosyalarındaki modül listelerini ve açıklamalarını güncelleyin.

---

## 💻 Kabuk (Bash) Kodlama Standartları

* **Strict Mode:** Betiklerin başında mutlaka `set -euo pipefail` kullanılmalıdır.
* **Görsel Geri Bildirim:** Konsol çıktıları için `common.sh` içerisindeki `log_info`, `log_success`, `log_warn`, `log_error` ve `log_header` fonksiyonları kullanılmalıdır.
* **Yetki Kontrolü:** Sistem düzeyinde işlem yapmadan önce `check_sudo` çağrılmalı ve `${SUDO_CMD}` ile yetkilendirme yönetilmelidir.
* **Çift Tırnak Kuralı:** Değişkenler her zaman `"${DEGISKEN}"` şeklinde çift tırnak içine alınmalıdır.
* **Fallback Güvencesi:** Kritik komutlarda (örneğin servis başlatma veya user grubu ekleme) sistemin çökmemesi için `|| true` veya hata yakalama kullanılmalıdır.

---

## 🧪 Test ve Doğrulama Yönergeleri

Herhangi bir değişiklik yapıldığında aşağıdaki testler terminalde koşturulmalıdır:

```bash
# 1. Debian Paketlerinin Derlenmesi Testi:
bash debian/build-deb.sh

# 2. Arch Split Paketlerinin Derlenmesi Testi:
bash arch/build-arch.sh

# 3. CLI Yükleyici Listeleme ve Yardım Testi:
./cli/pars-pkg-installer.sh --list
./cli/pars-pkg-installer.sh --help
```

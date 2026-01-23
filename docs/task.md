# REVISED-PROMPT.md - Bobaland Installer Only

Bro, paste prompt ini ke AI agent lu untuk setup repo **BOBALAND** aja yang connect ke dotfiles repo yang udah ada!

---

## 🎯 MISSION BRIEFING

Gua mau lu bantu setup **1 REPO AJA**: **Bobaland** - Installer script dengan README keren

**PENTING**: 
- ❌ **JANGAN** bikin repo Dotfiles (udah ada di: https://github.com/bondanbanuaji/Dotfiles)
- ✅ **CUMA** bikin installer yang nge-clone dan deploy dotfiles dari repo yang udah ada
- ✅ Focus ke repo: https://github.com/bondanbanuaji/bobaland

---

## 📋 BOBALAND REPO STRUCTURE

```
bobaland/
├── install.sh          # Interactive installer script
├── README.md           # Documentation dengan preview & badges
└── LICENSE             # MIT License
```

**That's it!** Cuma 3 files. Simple tapi powerful!

---

## 🚀 DETAILED REQUIREMENTS

### File 1: `install.sh` - Epic Interactive Installer

**Features yang HARUS ada:**
- ✅ Full interactive dengan animasi & progress bars
- ✅ Colored output (Red, Green, Yellow, Cyan, Purple)
- ✅ ASCII art banner (anime waifu yang gua kasih)
- ✅ Error handling yang proper
- ✅ Logging system (simpan di `~/.cache/bobaland/install_*.log`)
- ✅ Backup otomatis config lama sebelum install
- ✅ Menu interaktif untuk pilih komponen
- ✅ Clone dotfiles dari: `https://github.com/bondanbanuaji/Dotfiles.git`
- ✅ Deploy dotfiles pakai GNU Stow

**Menu Options:**
1. Full Installation (Recommended) - Install semua + deploy dotfiles
2. Install Packages Only - Cuma install packages
3. Deploy Dotfiles Only - Cuma deploy dotfiles (asumsi packages udah ada)
4. Custom Installation - Pilih-pilih mau install apa aja
5. Exit

**Packages yang di-install:**
```bash
# Window Manager & Wayland
hyprland
xdg-desktop-portal-hyprland
waybar
swaync
rofi-wayland
wlogout

# Terminal & Shell
ghostty  # (atau kitty/alacritty as fallback)
zsh
tmux

# Audio & Media
pipewire
wireplumber
cava

# Fonts
ttf-jetbrains-mono-nerd
ttf-font-awesome
noto-fonts-emoji

# Tools
neovim
stow
git
curl
wget
```

**Flow Install:**
1. Show banner dengan anime ASCII art
2. Check dependencies (git, stow, curl)
3. Show menu
4. Backup existing configs ke `~/.config-backup-TIMESTAMP/`
5. Install packages (kalau dipilih)
6. Clone dotfiles dari `https://github.com/bondanbanuaji/Dotfiles.git` ke `~/dotfiles`
7. Deploy dengan `stow .` di dalam `~/dotfiles`
8. Setup Zsh (change shell + install oh-my-zsh)
9. Post-install tasks (chmod scripts, create dirs)
10. Show completion message

**Anime ASCII Art Banner:**
```
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠟⠛⠛⠛⠿⠿⢿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡻⡿⣿⢿⠟⠋⠁⠀⣀⣠⣤⣤⣤⣀⣀⣀⣂⣀⣀⣀⣀⣀⡉⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⢀⢊⠐⠁⠀⠀⣠⣶⡿⠛⣉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⡔⠑⡀⠀⢀⣤⣾⣟⣫⡴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣷⣄⠈⠙⣟⠼⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⡠⠊⢀⡄⢀⣴⣿⣿⠟⡋⢁⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣷⡄⠈⠰⡔⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⡇⠀⠟⣴⣿⢟⠕⡡⢊⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠘⢄⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢠⢦⡁⠀⠇⢠⣾⣿⡟⣡⣾⣴⣿⣿⢋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠈⢆⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣾⢸⡇⠀⣴⣿⡿⢉⣼⣿⣿⡟⣼⣣⣾⣿⠿⣿⣿⣿⣿⡿⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣗⠀⣰⠀⠸⢿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣿⢻⢃⣾⣿⡿⠁⣾⣿⣿⣿⢣⢇⣿⣿⠏⡄⣿⣿⣿⣿⡇⣶⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠹⣿⣿⣿⣿⣿⡀⡇⠀⡄⡎⢻⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣾⡿⢠⣿⡟⡼⠁⣸⣿⣿⣿⡏⣾⣿⣿⠏⡼⡇⢻⢻⣿⣿⡇⡿⣧⡘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢻⡇⣿⣿⣿⡇⠁⣼⣷⣷⢸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢱⡟⣡⣿⢏⣼⠃⣰⣿⣿⣿⣿⢣⣿⣿⡏⣼⣶⣇⢸⠘⣿⣿⡇⣷⡙⣧⡈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡎⢿⣾⣿⣿⡇⢀⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠊⣼⣿⡏⣾⠃⣰⣿⣿⣿⣿⡿⣸⣿⡟⣠⣭⣭⣋⠈⠀⢿⣿⡇⣽⣿⣎⠻⣄⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡘⣿⣿⣿⣷⣿⣿⣿⣿⣜⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠟⢁⡴⣿⡿⣸⠇⣰⣿⣿⣿⣿⣿⢇⣻⡿⣱⣿⣿⣿⣿⣇⠸⡜⣿⡇⢻⣿⣿⣷⢋⣡⠹⣿⣿⣿⣿⣿⣿⣿⣿⣧⢹⣿⣿⣿⣿⣿⣿⣿⡏⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡿⢁⡠⢸⢧⣼⢣⠃⠐⣿⣿⣿⣿⣿⣿⢸⡿⢡⣿⣿⣿⣿⣿⣿⡄⣷⡘⣇⢸⣿⣿⣿⣿⣿⣦⡹⣿⣿⣿⣿⣿⣿⣿⣿⡆⢿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣯⣶⣿⢇⣿⣼⡏⠄⠐⣸⣿⣿⣿⣿⣿⡇⡾⠁⠛⠿⣿⣿⣿⣿⣿⣿⣿⣷⡈⢸⣿⣿⣿⣿⣿⣿⣷⣘⢿⣿⡟⣿⣿⣿⣿⣿⡘⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⡿⠈⡜⣱⣿⣿⣿⣿⣿⣿⡆⢡⣿⣶⣤⣀⠉⠓⢭⣻⣿⣿⣿⣷⣴⣿⣿⣿⠿⢿⣿⠿⠿⠃⠙⢿⡸⣿⣿⣿⣿⣇⠘⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⠃⠐⣰⡿⠿⢿⣿⣿⣿⣿⡇⢸⡏⣀⣀⣀⣠⣤⣤⣼⣿⣿⣿⣿⣿⣿⣿⠐⠋⠁⢀⣤⣤⣶⣶⣌⢡⢹⣿⡿⠿⡏⣄⠹⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⠀⣴⣿⢣⣿⢸⣿⣿⣿⣿⡇⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣤⣀⡈⠉⣿⢃⣿⣆⠿⠅⣷⢰⣸⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⢰⣿⣣⣾⣿⡿⣼⡏⣼⣿⠏⢹⣿⡇⣶⡜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⡘⠻⠋⣴⡀⢿⡆⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡟⣸⣿⣿⣿⣿⢡⣿⡇⡿⢡⣾⠇⣿⡇⠻⣿⡜⢿⣿⣿⣿⣿⣿⢛⣛⣛⡻⠿⣿⣿⣿⣿⣿⣿⣿⡿⣡⢠⢱⢘⣗⣿⣿⢸⣷⢸⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⡟⣸⡿⠀⣰⣿⢏⡆⣿⡇⣷⣌⠛⠚⠻⠿⠿⠿⢿⣜⢿⣿⡿⣫⣿⣿⣿⣿⣿⠿⢋⣼⠃⢸⡟⣤⢻⣿⣿⡞⣿⡅⣿⣿⣿⣿⣿⣿⡏⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⢡⣿⣿⣿⣿⢃⣿⡇⣼⣿⡟⣼⣿⢹⡇⣿⣿⣷⣶⡄⠀⠀⠀⠀⢸⣷⣶⣾⣿⣿⣿⠟⣉⣁⣘⣻⣯⠄⡟⣼⣿⣎⢿⣿⣧⢻⣷⠹⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⠏⠜⣛⣱⣶⣂⣾⣿⣧⣿⢍⣰⣿⣿⡎⡇⣿⣿⣿⣿⣿⣧⣿⠈⡻⣮⣙⣛⣭⡽⠖⢑⢡⣿⣿⣿⣿⡟⠘⣼⣿⣿⣿⡜⣟⣿⣼⣿⣧⣲⣦⡙⣛⠪⣁⢻⣿⣿⣿⣿
⣿⣿⣿⣿⡏⡆⢿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣿⠻⢿⣷⡀⣿⣿⣿⠏⡡⣸⣿⣧⣿⣦⠝⠟⣩⣶⣷⣿⣿⣷⡝⠿⣿⣏⣼⣿⣿⡿⢋⢡⣶⣿⣿⣿⣿⣿⣿⣷⣿⡇⣱⢸⣿⣿⣿⣿
⣿⣿⣿⡿⠁⠻⡘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠢⣝⢳⣿⣿⡇⠀⢹⣿⣿⣿⣿⡿⢗⣉⡿⢿⣿⠟⡙⢿⠇⠀⣿⣿⣿⠟⡡⠖⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⣡⢃⡎⣿⣿⣿⣿
⣿⣿⣿⠃⠀⠁⠈⠲⣍⡻⢿⣿⣿⣿⣿⣿⡿⠁⠀⢈⠳⡝⢿⠁⣤⠀⢿⣿⣿⠟⢰⣿⣿⣿⡎⠧⡘⠟⡀⢰⡄⢘⡟⣠⢊⡀⠀⠘⣿⣿⣿⣿⣿⣿⠿⢛⡡⠞⠁⠁⠳⠹⣿⣿⣿
⣿⣿⡏⠀⠀⠀⠀⠀⠀⠉⠓⢮⣍⡛⠿⠟⠁⠀⠀⣼⣷⡝⡄⢸⣿⣦⣈⣡⣴⣶⡈⣿⣿⡟⢴⣤⣄⣄⣠⣾⣷⠄⡸⣡⣾⠆⠀⠀⠈⠻⠿⣛⣩⠴⠚⠉⠀⠀⠀⠀⠀⠃⢻⣿⣿
⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠳⠶⣦⣤⣬⣭⣥⠟⣰⣿⣿⣿⣿⣿⣿⡇⣿⣿⡇⢿⣿⣿⣿⣿⣿⣿⡀⢧⣭⣭⣥⣤⣴⠶⠗⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿
⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒⠂⣀⠆⣾⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣇⢸⣿⣿⣿⣿⣿⣿⣿⣇⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⣿
⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⢋⢰⣿⣿⣿⣿⣿⣿⣿⣿⢠⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣷⠀⢻⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡸
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡟⡏⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⢸⣿⡟⠿⠿⠿⠿⠙⣿⡆⠘⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣧⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⢸⣿⣿⣶⣶⣶⣶⣾⣿⣿⡀⠉⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⡏⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║                                                                    ║
║ ██████╗  ██████╗ ██████╗  █████╗ ██╗      █████╗ ███╗   ██╗██████╗ ║
║ ██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗║
║ ██████╔╝██║   ██║██████╔╝███████║██║     ███████║██╔██╗ ██║██║  ██║║
║ ██╔══██╗██║   ██║██╔══██╗██╔══██║██║     ██╔══██║██║╚██╗██║██║  ██║║
║ ██████╔╝╚██████╔╝██████╔╝██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝║
║ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ║
║                                                                    ║
║                  Bobaland - My Arch-Hyprland                       ║
║                     By: Bondan Banuaji                             ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
```

---

### File 2: `README.md` - Professional Documentation

**Structure:**
```markdown
# Bobaland - My Arch-Hyprland

[Badges: Arch Linux, Hyprland, MIT License]

## Table of Contents
- Preview (with placeholder for screenshots/videos)
- Features
- Notes & Important Info
- Keybindings
- Installation (Quick install commands)
- What Gets Installed
- Dotfiles Repo (Link ke: https://github.com/bondanbanuaji/Dotfiles)
- Troubleshooting
- Post-Installation
- Updating
- Uninstallation
- Credits

## Key Sections:

**Preview**: 
- Placeholder untuk screenshots
- Placeholder untuk video demo
- Note: "Screenshots and videos will be added soon!"

**Features**:
- ✨ Interactive Installation
- 🔒 Safe & Reversible (Auto backup)
- 📦 Complete Setup
- 🎨 Beautiful ASCII art interface
- 📊 Progress bars and colored output

**Installation**:
```bash
git clone --depth=1 https://github.com/bondanbanuaji/bobaland.git
cd bobaland
chmod +x install.sh
./install.sh
```

**Link to Dotfiles**:
👉 **[bondanbanuaji/Dotfiles](https://github.com/bondanbanuaji/Dotfiles)**

"The installer automatically clones and deploys these dotfiles using GNU Stow."

**Credits**:
- r/unixporn
- JaKooLit/Hyprland-Dots
- Hyde-project/hyde
- mylinuxforwork/dotfiles
- ViegPhunt/Arch-Hyprland
```

---

### File 3: `LICENSE` - MIT License

Standard MIT License dengan:
- Copyright (c) 2026 bondanbanuaji
- Standard MIT license text

---

## 🎯 CRITICAL POINTS

**install.sh MUST:**
1. ✅ Clone dari `https://github.com/bondanbanuaji/Dotfiles.git`
2. ✅ Clone ke direktori `~/dotfiles`
3. ✅ Pakai `stow .` untuk deploy (jangan `stow -t ~`)
4. ✅ Handle error kalau dotfiles dir udah ada (git pull instead)
5. ✅ Make viegphunt scripts executable: `chmod +x ~/.config/viegphunt/*`
6. ✅ Create necessary dirs: `~/Pictures/Screenshots`, `~/.cache/cava`
7. ✅ Backup ke `~/.config-backup-TIMESTAMP/`
8. ✅ Log semua ke `~/.cache/bobaland/install_TIMESTAMP.log`

**install.sh MUST NOT:**
1. ❌ Bikin repo dotfiles baru
2. ❌ Copy files manual (must use stow)
3. ❌ Hardcode paths (use $HOME variables)
4. ❌ Run as root (check dengan if EUID -eq 0)

---

## 📝 COMPLETE install.sh TEMPLATE

```bash
#!/bin/bash

# ============================================================================
#  BOBALAND - Arch Linux Hyprland Auto Installer
#  Author: bondanbanuaji
#  Repo: https://github.com/bondanbanuaji/bobaland
#  Dotfiles: https://github.com/bondanbanuaji/Dotfiles
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Logging
LOG_DIR="$HOME/.cache/bobaland"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOG_DIR"

log() { echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" | tee -a "$LOG_FILE"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*" | tee -a "$LOG_FILE"; }
log_info() { echo -e "${CYAN}[INFO]${NC} $*" | tee -a "$LOG_FILE"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "$LOG_FILE"; }

# Banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
[PASTE ANIME ASCII ART DI SINI]
EOF
    echo -e "${NC}"
    echo -e "${CYAN}${BOLD}    Arch Linux Hyprland Auto Installer${NC}"
    echo -e "${WHITE}    Author: bondanbanuaji${NC}"
    echo -e "${WHITE}    Repo: https://github.com/bondanbanuaji/bobaland${NC}"
    echo -e "${WHITE}    Dotfiles: https://github.com/bondanbanuaji/Dotfiles${NC}"
    echo ""
}

# Progress bar
progress_bar() {
    local duration=$1
    local message=$2
    local width=50
    echo -ne "${CYAN}${message}${NC} ["
    for ((i=0; i<=width; i++)); do
        echo -ne "${GREEN}▓${NC}"
        sleep $(awk "BEGIN {print $duration/$width}")
    done
    echo -e "] ${GREEN}✓${NC}"
}

# Dependency check
check_dependencies() {
    log_info "Checking dependencies..."
    local deps=("git" "stow" "wget" "curl")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_warn "Missing dependencies: ${missing_deps[*]}"
        echo -e "${YELLOW}Installing missing dependencies...${NC}"
        sudo pacman -S --needed --noconfirm "${missing_deps[@]}"
    fi
    
    log_success "All dependencies satisfied"
}

# Backup configs
backup_configs() {
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    log_info "Creating backup at: $backup_dir"
    mkdir -p "$backup_dir"
    
    [ -d "$HOME/.config" ] && cp -r "$HOME/.config" "$backup_dir/"
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$backup_dir/"
    [ -f "$HOME/.tmux.conf" ] && cp "$HOME/.tmux.conf" "$backup_dir/"
    
    log_success "Backup created: $backup_dir"
}

# Clone dotfiles
clone_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    local dotfiles_repo="https://github.com/bondanbanuaji/Dotfiles.git"
    
    log_info "Cloning dotfiles repository..."
    
    if [ -d "$dotfiles_dir" ]; then
        log_warn "Dotfiles directory exists. Updating..."
        cd "$dotfiles_dir"
        git pull
    else
        git clone --depth=1 "$dotfiles_repo" "$dotfiles_dir"
    fi
    
    log_success "Dotfiles ready"
}

# Install packages
install_packages() {
    log_info "Installing packages..."
    
    local packages=(
        "hyprland" "xdg-desktop-portal-hyprland"
        "ghostty" "zsh" "tmux"
        "waybar" "swaync" "rofi-wayland" "wlogout"
        "pipewire" "wireplumber" "cava"
        "ttf-jetbrains-mono-nerd" "ttf-font-awesome" "noto-fonts-emoji"
        "neovim" "stow"
    )
    
    echo -e "${CYAN}Packages to install:${NC}"
    printf '%s\n' "${packages[@]}" | column
    echo ""
    
    read -p "Continue? [Y/n] " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        sudo pacman -S --needed --noconfirm "${packages[@]}"
        log_success "Packages installed"
    else
        log_warn "Skipped package installation"
    fi
}

# Deploy dotfiles
deploy_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    log_info "Deploying dotfiles with GNU Stow..."
    cd "$dotfiles_dir"
    stow -v .
    log_success "Dotfiles deployed"
}

# Setup Zsh
setup_zsh() {
    log_info "Setting up Zsh..."
    
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        log_success "Default shell changed to Zsh"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# Post-install
post_install() {
    log_info "Running post-install tasks..."
    
    [ -d "$HOME/.config/viegphunt" ] && chmod +x "$HOME/.config/viegphunt"/*
    mkdir -p "$HOME/Pictures/Screenshots" "$HOME/.cache/cava"
    
    log_success "Post-install complete"
}

# Menu
show_menu() {
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║     Installation Menu                 ║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}1)${NC} Full Installation (Recommended)"
    echo -e "${WHITE}2)${NC} Install Packages Only"
    echo -e "${WHITE}3)${NC} Deploy Dotfiles Only"
    echo -e "${WHITE}4)${NC} Custom Installation"
    echo -e "${WHITE}5)${NC} Exit"
    echo ""
    read -p "$(echo -e ${CYAN}Select [1-5]: ${NC})" choice
    
    case $choice in
        1) full_installation ;;
        2) install_packages ;;
        3) clone_dotfiles && deploy_dotfiles ;;
        4) custom_installation ;;
        5) exit 0 ;;
        *) log_error "Invalid option"; show_menu ;;
    esac
}

# Full installation
full_installation() {
    log_info "Starting full installation..."
    check_dependencies
    backup_configs
    install_packages
    clone_dotfiles
    deploy_dotfiles
    setup_zsh
    post_install
    show_completion
}

# Custom installation
custom_installation() {
    echo -e "${CYAN}Select components:${NC}"
    echo ""
    
    read -p "Backup configs? [Y/n] " backup
    read -p "Install packages? [Y/n] " packages
    read -p "Deploy dotfiles? [Y/n] " dotfiles
    read -p "Setup Zsh? [Y/n] " zsh
    
    [[ $backup =~ ^[Yy]$ ]] && backup_configs
    [[ $packages =~ ^[Yy]$ ]] && install_packages
    [[ $dotfiles =~ ^[Yy]$ ]] && clone_dotfiles && deploy_dotfiles
    [[ $zsh =~ ^[Yy]$ ]] && setup_zsh
    
    post_install
    show_completion
}

# Completion
show_completion() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ✓  Installation Complete!                              ║
    ║                                                           ║
    ║   Your Bobaland Hyprland setup is ready!                ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  ${WHITE}1.${NC} Logout and login again"
    echo -e "  ${WHITE}2.${NC} Select Hyprland from display manager"
    echo -e "  ${WHITE}3.${NC} Press ${YELLOW}SUPER + H${NC} for keybindings"
    echo ""
    echo -e "${CYAN}Useful commands:${NC}"
    echo -e "  ${WHITE}•${NC} Logs: ${YELLOW}cat $LOG_FILE${NC}"
    echo -e "  ${WHITE}•${NC} Restore: ${YELLOW}cp -r ~/.config-backup-*/.config ~/${NC}"
    echo ""
    echo -e "${GREEN}Enjoy! 🚀${NC}"
}

# Main
main() {
    show_banner
    
    if [ "$EUID" -eq 0 ]; then
        log_error "Don't run as root"
        exit 1
    fi
    
    if [ ! -f /etc/arch-release ]; then
        log_error "Arch Linux only"
        exit 1
    fi
    
    show_menu
}

main "$@"
```

---

## 🎬 EXECUTION COMMAND

Setelah AI agent bikin semua files:

```bash
cd ~/bobaland
git init
git add .
git commit -m "Initial commit: Bobaland installer"
git remote add origin https://github.com/bondanbanuaji/bobaland.git
git push -u origin main
```

---

## ✅ CHECKLIST

AI Agent harus ensure:
- [ ] Cuma 3 files: install.sh, README.md, LICENSE
- [ ] install.sh chmod +x
- [ ] Anime ASCII art ada di banner
- [ ] Clone dari https://github.com/bondanbanuaji/Dotfiles.git
- [ ] Stow deployment correct
- [ ] Error handling complete
- [ ] Logging working
- [ ] Backup working
- [ ] Menu interactive
- [ ] README lengkap dengan badges & links
- [ ] LICENSE MIT correct

---

**GO EXECUTE THIS! Fokus ke bobaland repo aja, dotfiles udah siap!** 🚀
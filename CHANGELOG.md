# Changelog

## [1.0.0] - 2026-01-17
### Major Refactor
- **Restructure**: Reorganized repository into standard `.config`, `assets`, `scripts`, `docs` layout.
- **Cleanup**: Removed duplicate configurations, broken symlinks (hypr, waybar), and bloat (`Wallpapers/` root folder).
- **Scripts**:
  - Rewrote `install.sh` to be modular, safer (backup support), and interactive.
  - Added `scripts/setup-wallpapers.sh` for easy asset management.
  - Updated `scripts/setup-grub.sh` to support new path structure.
- **Documentation**:
  - Created professional `README.md`.
  - Added comprehensive `DOCUMENTATION.md`.
  - Added `COMPONENTS.md` and `THEMING.md`.
  - Organized existing docs into `docs/`.
- **Assets**: Consolidated wallpapers and boot themes into `assets/`.

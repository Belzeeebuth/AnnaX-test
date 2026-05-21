#!/usr/bin/env bash
# AnnaX Linux — Script de build ISO

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$SCRIPT_DIR/out"
WORK_DIR="$SCRIPT_DIR/work"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

msg()  { echo -e "${GREEN}▶${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
err()  { echo -e "${RED}✗${NC} $*" >&2; exit 1; }

banner() {
    echo -e "${MAGENTA}${BOLD}"
    echo "   █████╗ ███╗   ██╗███╗   ██╗ █████╗ ██╗  ██╗"
    echo "  ██╔══██╗████╗  ██║████╗  ██║██╔══██╗╚██╗██╔╝"
    echo "  ███████║██╔██╗ ██║██╔██╗ ██║███████║ ╚███╔╝ "
    echo "  ██╔══██║██║╚██╗██║██║╚██╗██║██╔══██║ ██╔██╗ "
    echo "  ██║  ██║██║ ╚████║██║ ╚████║██║  ██║██╔╝ ██╗"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "${NC}  AnnaX Linux — ISO Builder"
    echo ""
}

check_deps() {
    msg "Vérification des dépendances..."
    local missing=()
    for dep in mkarchiso mksquashfs; do
        command -v "$dep" &>/dev/null || missing+=("$dep")
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        err "Manquant: ${missing[*]}\nInstalle avec: sudo pacman -S archiso squashfs-tools"
    fi

    [[ $EUID -eq 0 ]] || err "Lance en root : sudo ./build.sh"
}

clean() {
    msg "Nettoyage des fichiers temporaires..."
    [[ $EUID -eq 0 ]] || err "Lance en root : sudo ./build.sh clean"
    [[ -d "$WORK_DIR" ]] && rm -rf "$WORK_DIR"
    [[ -d "$OUT_DIR" ]] && rm -rf "$OUT_DIR"
    msg "Fait."
}

build() {
    banner
    msg "Préparation..."
    mkdir -p "$OUT_DIR"

    chmod +x "$SCRIPT_DIR/airootfs/usr/local/bin/annax"
    chmod +x "$SCRIPT_DIR/airootfs/usr/local/bin/annax-install"
    chmod +x "$SCRIPT_DIR/airootfs/root/dotfiles/i3/polybar/launch.sh" 2>/dev/null || true

    msg "Build de l'ISO AnnaX en cours..."
    warn "Cela peut prendre 15–30 minutes selon ta connexion."
    echo ""

    mkarchiso -v \
        -w "$WORK_DIR" \
        -o "$OUT_DIR" \
        "$SCRIPT_DIR"

    echo ""
    msg "ISO créée avec succès :"
    ls -lh "$OUT_DIR"/*.iso 2>/dev/null || warn "Aucune ISO trouvée dans $OUT_DIR"
}

test_qemu() {
    local iso
    iso=$(ls "$OUT_DIR"/*.iso 2>/dev/null | head -1)
    [[ -z "$iso" ]] && err "Aucune ISO trouvée. Lance './build.sh build' d'abord."

    command -v qemu-system-x86_64 &>/dev/null || \
        err "QEMU non installé : sudo pacman -S qemu-full"

    local ovmf=""
    for f in /usr/share/edk2/x64/OVMF.4m.fd \
              /usr/share/edk2/x64/OVMF.fd \
              /usr/share/OVMF/OVMF_CODE.fd; do
        [[ -f "$f" ]] && { ovmf="$f"; break; }
    done
    [[ -z "$ovmf" ]] && err "OVMF non trouvé. Installe : sudo pacman -S edk2-ovmf"

    # Disque virtuel pour l'installation (50 Go)
    local disk="$SCRIPT_DIR/annax-test.qcow2"
    if [[ ! -f "$disk" ]]; then
        msg "Création du disque virtuel (50 Go) : $disk"
        if [[ -n "${SUDO_USER:-}" ]]; then
            sudo -u "$SUDO_USER" qemu-img create -f qcow2 "$disk" 50G
        else
            qemu-img create -f qcow2 "$disk" 50G
        fi
    else
        msg "Disque virtuel existant : $disk"
    fi

    msg "Lancement de l'ISO AnnaX dans QEMU..."
    warn "Réseau : ethernet virtuel (NetworkManager le détecte automatiquement)"
    warn "Copier-coller : SPICE activé — installe spice-vdagent dans la VM si besoin"

    command -v remote-viewer &>/dev/null || \
        warn "remote-viewer non trouvé, installe : sudo pacman -S virt-viewer"

    local qemu_cmd="qemu-system-x86_64 \
        -enable-kvm \
        -m 4G \
        -smp 4 \
        -bios \"$ovmf\" \
        -cdrom \"$iso\" \
        -drive file=\"$disk\",format=qcow2,if=virtio \
        -boot order=d,menu=on \
        -device virtio-vga \
        -device virtio-serial-pci \
        -chardev spicevmc,id=vdagent,name=vdagent \
        -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
        -spice port=5930,disable-ticketing=on \
        -display spice-app \
        -netdev user,id=net0 \
        -device virtio-net-pci,netdev=net0"

    if [[ -n "${SUDO_USER:-}" ]]; then
        sudo -u "$SUDO_USER" \
            DISPLAY="${DISPLAY:-:0}" \
            WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}" \
            XDG_RUNTIME_DIR="/run/user/$(id -u "$SUDO_USER")" \
            bash -c "$qemu_cmd"
    else
        eval "$qemu_cmd"
    fi
}

case "${1:-build}" in
    build) check_deps; build ;;
    clean) clean ;;
    test)  test_qemu ;;
    all)   check_deps; clean; build ;;
    *)
        banner
        echo "Usage: sudo ./build.sh [commande]"
        echo ""
        echo "  build  — Construit l'ISO AnnaX (défaut)"
        echo "  clean  — Nettoie les fichiers temporaires"
        echo "  test   — Teste l'ISO dans QEMU"
        echo "  all    — Nettoie puis build"
        echo ""
        ;;
esac

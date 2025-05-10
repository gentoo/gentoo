import glob
import os
import re

def find_latest_gentoo_initramfs():
    candidates = glob.glob('/boot/initramfs-*-gentoo-dist.img')
    if not candidates:
        raise FileNotFoundError("No Gentoo dist initramfs found in /boot")

    def extract_version(path):
        basename = os.path.basename(path)
        match = re.search(r'initramfs-(\d+\.\d+\.\d+)-gentoo-dist\.img', basename)
        if match:
            return tuple(map(int, match.group(1).split('.')))
        return (0, 0, 0)

    candidates.sort(key=lambda x: extract_version(x), reverse=True)
    return candidates[0]

def extract_kernel_simple_version(initramfs_path):
    basename = os.path.basename(initramfs_path)
    match = re.search(r'initramfs-(\d+\.\d+\.\d+)-gentoo-dist\.img', basename)
    if match:
        return match.group(1)
    raise ValueError(f"Could not extract simple version from initramfs filename: {basename}")

def run():
    dracut_options = [
        "-H", "-f",
        "-o systemd", "-o systemd-initrd", "-o systemd-networkd", "-o dracut-systemd", "-o plymouth",
        "--early-microcode"
    ]
    latest_initramfs = find_latest_gentoo_initramfs()
    simple_version = extract_kernel_simple_version(latest_initramfs)
    dracut_options.append(f'--kver={simple_version}-gentoo-dist')
    return None

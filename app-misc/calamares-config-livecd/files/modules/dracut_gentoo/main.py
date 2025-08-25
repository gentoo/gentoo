import subprocess
import glob
import os
import re
import libcalamares
from libcalamares.utils import target_env_process_output

def find_latest_gentoo_initramfs():
    root_mount_point = libcalamares.globalstorage.value("rootMountPoint")
    if not root_mount_point:
        raise ValueError("rootMountPoint not set in global storage")
    
    target_boot_path = os.path.join(root_mount_point, 'boot')
    search_pattern = os.path.join(target_boot_path, 'initramfs-*-gentoo-dist.img')
    candidates = glob.glob(search_pattern)
    
    if not candidates:
        raise FileNotFoundError(f"No Gentoo dist initramfs found in {target_boot_path}")

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
    try:
        dracut_options = [
            "-H", "-f",
            "-o", "systemd", "-o", "systemd-initrd", "-o", "systemd-networkd", 
            "-o", "dracut-systemd", "-o", "plymouth",
            "--early-microcode"
        ]
        
        latest_initramfs = find_latest_gentoo_initramfs()
        simple_version = extract_kernel_simple_version(latest_initramfs)
        dracut_options.append(f'--kver={simple_version}-gentoo-dist')
        
        result = target_env_process_output(['dracut'] + dracut_options)
        libcalamares.utils.debug(f"Successfully created initramfs for kernel {simple_version}-gentoo-dist")
        
    except FileNotFoundError as e:
        libcalamares.utils.warning(f"No Gentoo initramfs found: {e}")
        return 1
    except ValueError as e:
        libcalamares.utils.warning(f"Failed to extract kernel version: {e}")
        return 1
    except subprocess.CalledProcessError as cpe:
        libcalamares.utils.warning(f"Dracut failed with output: {cpe.output}")
        return cpe.returncode
    
    return None
#!/usr/bin/env python3
# A simple script to find ELF and WebAssembly executables in a directory tree.
# Spdx-License-Identifier: GPL-2.0-or-later
import os
import struct
import argparse

# Magic numbers
ELF_MAGIC = b"\x7fELF"
WASM_MAGIC = b"\x00asm"

# Machine ID Mapping for things in Chromium
ELF_MACHINE_MAP = {
    0x02: "SPARC",
    0x03: "x86",
    0x08: "MIPS",
    0x12: "SPARC",
    0x14: "PowerPC",
    0x15: "PowerPC64",
    0x28: "ARM",
    0x2B: "SPARC V9",
    0x34: "SuperH",
    0x3E: "x86_64",
    0xB7: "AArch64",
    0xA4: "Hexagon",
    0xF3: "RISC-V",
}

# Extensions that are guaranteed non-ELF/non-WASM.
# Derived from `tar tvf chromium-*.tar.xz` (all exts with ≥80 occurrences,
# minus .bin/.out/.node/.a which can legitimately be ELF).
# fmt: off
_SKIP_EXTENSIONS = frozenset({
    # C / C++ / Objective-C
    '.c', '.cc', '.cpp', '.cxx', '.h', '.hh', '.hpp', '.hxx',
    '.inc', '.inl', '.m', '.mm', '.tq',
    # Assembly
    '.S', '.asm', '.s',
    # Compiled languages
    '.cs', '.dart', '.go', '.java', '.kt', '.rs', '.swift',
    # Scripting & interpreted languages
    '.bat', '.cjs', '.coffee', '.cts', '.js', '.mjs', '.mts',
    '.php', '.pl', '.py', '.pyi', '.rb', '.sh', '.ts',
    # Web & markup
    '.css', '.htm', '.html', '.scss', '.template', '.tmpl',
    '.tpl', '.ui', '.xml', '.xsd', '.xsl',
    # Shader & GPU languages
    '.comp', '.frag', '.glsl', '.hlsl', '.metal', '.rts',
    '.sksl', '.tesc', '.tese', '.vert', '.vk', '.wgsl',
    # Protocol / schema / interface definitions
    '.fbs', '.idl', '.mojom', '.pbtxt', '.pdl', '.proto',
    '.test-mojom', '.textpb', '.textproto',
    # Compiler IR & intermediate formats
    '.bc', '.dxbc', '.ll', '.mlir', '.spv', '.spvasm', '.td',
    # Build systems & project files
    '.BUILD', '.am', '.bazel', '.build', '.bzl', '.cmake',
    '.gn', '.gni', '.grd', '.grdp', '.gyp', '.gypi', '.in',
    '.lock', '.mak', '.mk', '.star',
    # Configuration & data serialisation
    '.cfg', '.conf', '.hjson', '.json', '.json5', '.toml',
    '.yaml', '.yml',
    # Documentation & text
    '.dox', '.man', '.md', '.mdoc', '.po', '.rst', '.txt',
    # Hashes & signatures
    '.sha1', '.sha256',
    # Cryptographic material
    '.crl', '.crt', '.der', '.key', '.pem',
    # Test & comparison data
    '.chromium', '.errors', '.expected', '.golden',
    '.mock-http-headers', '.output', '.ref', '.snap',
    '.stderr', '.test',
    # VCS & tooling config
    '.clang-format', '.eslintrc', '.gitattributes', '.gitignore',
    '.nycrc', '.pydeps', '.yapf',
    # Translation & locale
    '.ucm', '.xtb',
    # Images
    '.avif', '.bmp', '.gif', '.ico', '.icon', '.jpeg', '.jpg',
    '.pdf', '.png', '.svg', '.tiff', '.webp',
    # Audio & video
    '.flac', '.mkv', '.mp3', '.mp4', '.ogg', '.opus', '.wav',
    '.webm',
    # Fonts
    '.otf', '.ttf', '.woff', '.woff2',
    # Archives
    '.7z', '.bz2', '.gz', '.tar', '.xz', '.zip', '.zst',
    # Source maps
    '.map',
    # Chromium-specific data
    '.ctb', '.filter', '.hlo', '.onc', '.orth', '.plist',
    '.skrp', '.utb',
    # Miscellaneous non-executable data
    '.csv', '.dat', '.data', '.def', '.dict', '.diff', '.info',
    '.log', '.m4', '.orig', '.pac', '.patch', '.pb', '.rc',
    '.sql', '.t', '.tflite',
})
# fmt: on

# Minimum file size for a valid ELF header (20 bytes needed for parsing)
_MIN_FILE_SIZE = 20


def get_elf_info(fd):
    """Parses ELF header using the file's own endianness."""
    os.lseek(fd, 0, os.SEEK_SET)
    header = os.read(fd, 20)

    if len(header) < 20:
        return None

    # Offset 4: 1=32-bit, 2=64-bit
    bit_mode = "32-bit" if header[4] == 1 else "64-bit"

    # Offset 5: 1=LSB (Little Endian), 2=MSB (Big Endian)
    endian_byte = header[5]
    endian = "<" if endian_byte == 1 else ">"
    endian_name = "LSB" if endian_byte == 1 else "MSB"

    # Machine ID is 2 bytes at offset 18
    machine_id = struct.unpack(f"{endian}H", header[18:20])[0]

    # Object Type is 2 bytes at offset 16
    obj_type_id = struct.unpack(f"{endian}H", header[16:18])[0]
    obj_types = {1: "relocatable", 2: "executable", 3: "shared object", 4: "core"}
    obj_type = obj_types.get(obj_type_id, "unknown type")

    arch = ELF_MACHINE_MAP.get(machine_id, f"Unknown (0x{machine_id:x})")
    return f"ELF {bit_mode} {endian_name} {arch} ({obj_type})"


def scan_path(root_path, show_elf, show_wasm):
    try:
        with os.scandir(root_path) as it:
            for entry in it:
                if entry.is_dir(follow_symlinks=False):
                    scan_path(entry.path, show_elf, show_wasm)
                elif entry.is_file(follow_symlinks=False):
                    # Skip files with known non-ELF/WASM extensions
                    ext = os.path.splitext(entry.name)[1].lower()
                    if ext in _SKIP_EXTENSIONS:
                        continue

                    # Skip files too small for a valid ELF header
                    try:
                        if entry.stat(follow_symlinks=False).st_size < _MIN_FILE_SIZE:
                            continue
                    except OSError:
                        continue

                    fd = None
                    try:
                        fd = os.open(entry.path, os.O_RDONLY | os.O_NOFOLLOW)

                        magic = os.read(fd, 4)

                        if magic == ELF_MAGIC and show_elf:
                            info = get_elf_info(fd)
                            if info:
                                print(f"{entry.path} -> {info}")

                        elif magic == WASM_MAGIC and show_wasm:
                            print(f"{entry.path} -> WebAssembly binary")

                        # Performance: Drop from page cache
                        os.posix_fadvise(fd, 0, 0, os.POSIX_FADV_DONTNEED)
                    except (PermissionError, OSError):
                        continue
                    finally:
                        if fd is not None:
                            os.close(fd)
    except (PermissionError, OSError):
        pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Fast Linux binary sniffer")
    parser.add_argument("directory", help="Directory to scan")
    parser.add_argument("--elf", action="store_true", help="Only show ELF files")
    parser.add_argument("--wasm", action="store_true", help="Only show WASM files")

    args = parser.parse_args()

    # If neither is specified, default to showing both
    show_elf = args.elf or (not args.elf and not args.wasm)
    show_wasm = args.wasm or (not args.elf and not args.wasm)

    scan_path(args.directory, show_elf, show_wasm)

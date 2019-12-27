# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler32-1.0.3
aho-corasick-0.6.10
aho-corasick-0.7.3
andrew-0.2.1
android_glue-0.2.3
ansi_term-0.11.0
approx-0.3.2
arc-swap-0.3.11
argon2rs-0.2.5
arrayvec-0.4.10
atty-0.2.11
autocfg-0.1.4
backtrace-0.3.30
backtrace-sys-0.1.28
base64-0.10.1
bindgen-0.33.2
bitflags-1.1.0
blake2-rfc-0.2.18
block-0.1.6
byteorder-1.3.2
bzip2-0.3.3
bzip2-sys-0.1.7
cc-1.0.37
cexpr-0.2.3
cfg-if-0.1.9
cgl-0.2.3
clang-sys-0.22.0
clap-2.33.0
clipboard-win-2.2.0
cloudabi-0.0.3
cmake-0.1.40
cocoa-0.18.4
color_quant-1.0.1
constant_time_eq-0.1.3
core-foundation-0.6.4
core-foundation-sys-0.6.2
core-graphics-0.17.3
core-text-13.2.0
crc32fast-1.2.0
crossbeam-channel-0.3.8
crossbeam-deque-0.6.3
crossbeam-epoch-0.7.1
crossbeam-queue-0.1.2
crossbeam-utils-0.6.5
deflate-0.7.19
derivative-1.0.2
dirs-1.0.5
dlib-0.4.1
downcast-rs-1.0.4
dtoa-0.4.4
dunce-1.0.0
dwrote-0.9.0
either-1.5.2
embed-resource-1.2.0
env_logger-0.5.13
env_logger-0.6.1
errno-0.2.4
errno-dragonfly-0.1.1
euclid-0.19.9
euclid_macros-0.1.0
expat-sys-2.1.6
failure-0.1.5
failure_derive-0.1.5
filetime-0.2.5
fnv-1.0.6
foreign-types-0.3.2
foreign-types-0.4.0
foreign-types-macros-0.1.0
foreign-types-shared-0.1.1
foreign-types-shared-0.2.0
freetype-rs-0.19.1
freetype-sys-0.7.1
fsevent-0.4.0
fsevent-sys-2.0.1
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
gcc-0.3.55
gif-0.10.2
gleam-0.6.17
gl_generator-0.11.0
glob-0.2.11
glutin-0.21.0
glutin_egl_sys-0.1.3
glutin_emscripten_sys-0.1.0
glutin_gles2_sys-0.1.3
glutin_glx_sys-0.1.5
glutin_wgl_sys-0.1.3
http_req-0.5.0
humantime-1.2.0
idna-0.1.5
image-0.21.2
inflate-0.4.5
inotify-0.6.1
inotify-sys-0.1.3
iovec-0.1.2
itoa-0.4.4
jpeg-decoder-0.1.15
kernel32-sys-0.2.2
khronos_api-3.1.0
lazycell-1.2.1
lazy_static-1.3.0
libc-0.2.58
libflate-0.1.23
libloading-0.5.1
libz-sys-1.0.25
line_drawing-0.7.0
linked-hash-map-0.5.2
lock_api-0.1.5
log-0.4.6
lzw-0.10.0
malloc_buf-0.0.6
matches-0.1.8
memchr-1.0.2
memchr-2.2.0
memmap-0.7.0
memoffset-0.2.1
mio-0.6.19
mio-anonymous-pipes-0.1.0
mio-extras-2.0.5
mio-named-pipes-0.1.6
mio-uds-0.6.7
miow-0.2.1
miow-0.3.3
named_pipe-0.3.0
native-tls-0.2.3
net2-0.2.33
nix-0.14.1
nodrop-0.1.13
nom-3.2.1
nom-4.2.3
notify-4.0.12
num_cpus-1.10.1
num-derive-0.2.5
num-integer-0.1.41
num-iter-0.1.39
num-rational-0.2.2
numtoa-0.1.0
num-traits-0.2.8
objc-0.2.6
objc-foundation-0.1.1
objc_id-0.1.1
openssl-0.10.23
openssl-probe-0.1.2
openssl-sys-0.9.47
ordered-float-1.0.2
osmesa-sys-0.1.2
owning_ref-0.4.0
parking_lot-0.7.1
parking_lot_core-0.4.0
peeking_take_while-0.1.2
percent-encoding-1.0.1
phf-0.7.24
phf_codegen-0.7.24
phf_generator-0.7.24
phf_shared-0.7.24
pkg-config-0.3.14
png-0.14.1
podio-0.1.6
proc-macro2-0.4.30
quick-error-1.2.2
quote-0.3.15
quote-0.6.12
rand-0.6.5
rand_chacha-0.1.1
rand_core-0.3.1
rand_core-0.4.0
rand_hc-0.1.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rayon-1.1.0
rayon-core-1.5.0
rdrand-0.4.0
redox_syscall-0.1.54
redox_termios-0.1.1
redox_users-0.3.0
regex-0.2.11
regex-1.1.7
regex-syntax-0.5.6
regex-syntax-0.6.7
remove_dir_all-0.5.2
rustc-demangle-0.1.15
rustc_tools_util-0.2.0
rustc_version-0.2.3
rusttype-0.7.7
ryu-0.2.8
same-file-1.0.4
schannel-0.1.15
scoped_threadpool-0.1.9
scopeguard-0.3.3
security-framework-0.3.1
security-framework-sys-0.3.1
semver-0.9.0
semver-parser-0.7.0
serde-1.0.92
serde_derive-1.0.92
serde_json-1.0.39
serde_yaml-0.8.9
servo-fontconfig-0.4.0
servo-fontconfig-sys-4.0.7
shared_library-0.1.9
signal-hook-0.1.9
signal-hook-registry-1.0.1
siphasher-0.2.3
slab-0.4.2
smallvec-0.6.10
smithay-client-toolkit-0.4.6
smithay-client-toolkit-0.6.2
smithay-clipboard-0.3.3
socket2-0.3.9
spsc-buffer-0.1.1
stable_deref_trait-1.1.1
static_assertions-0.3.3
stb_truetype-0.2.6
strsim-0.8.0
syn-0.15.36
synstructure-0.10.2
tempfile-3.0.8
termcolor-1.0.5
terminfo-0.6.1
termion-1.5.3
textwrap-0.11.0
thread_local-0.3.6
tiff-0.2.2
time-0.1.42
ucd-util-0.1.3
unicase-2.4.0
unicode-bidi-0.3.4
unicode-normalization-0.1.8
unicode-width-0.1.5
unicode-xid-0.1.0
url-1.7.2
utf8parse-0.1.1
utf8-ranges-1.0.3
vcpkg-0.2.6
vec_map-0.8.1
version_check-0.1.5
void-1.0.2
vswhom-0.1.0
vswhom-sys-0.1.0
vte-0.3.3
walkdir-2.2.8
wayland-client-0.21.13
wayland-client-0.23.5
wayland-commons-0.21.13
wayland-commons-0.23.5
wayland-protocols-0.21.13
wayland-protocols-0.23.5
wayland-scanner-0.21.13
wayland-scanner-0.23.5
wayland-sys-0.21.13
wayland-sys-0.23.5
which-1.0.5
widestring-0.4.0
winapi-0.2.8
winapi-0.3.7
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
winit-0.19.1
winpty-sys-0.4.3
winreg-0.5.1
ws2_32-sys-0.2.1
x11-clipboard-0.3.2
x11-dl-2.18.3
xcb-0.8.2
xdg-2.2.0
xml-rs-0.8.0
yaml-rust-0.4.3
zip-0.5.2
"

MY_PV="${PV//_rc/-rc}"

inherit bash-completion-r1 cargo desktop eutils

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://github.com/jwilm/alacritty"
SRC_URI="https://github.com/jwilm/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64"
IUSE=""

DEPEND="
	media-libs/fontconfig:=
	media-libs/freetype:2
	x11-libs/libxcb
"

RDEPEND="${DEPEND}
	sys-libs/zlib
	sys-libs/ncurses:0
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/opengl
"

BDEPEND="dev-util/cmake
	>=virtual/rust-1.32.0
"

DOCS=( CHANGELOG.md docs/ansicode.txt INSTALL.md README.md alacritty.yml )

QA_FLAGS_IGNORED="usr/bin/alacritty"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	CARGO_INSTALL_PATH="alacritty" cargo_src_install

	newbashcomp extra/completions/alacritty.bash alacritty

	insinto /usr/share/fish/vendor_completions.d/
	doins extra/completions/alacritty.fish

	insinto /usr/share/zsh/site-functions
	doins extra/completions/_alacritty

	domenu extra/linux/alacritty.desktop
	newicon extra/logo/alacritty-term.svg Alacritty.svg

	newman extra/alacritty.man alacritty.1

	insinto /usr/share/alacritty/scripts
	doins -r scripts/*

	einstalldocs
}

pkg_postinst() {
	optfeature "wayland support" dev-libs/wayland
	optfeature "apply-tilix-colorscheme script dependency" dev-python/pyyaml
}

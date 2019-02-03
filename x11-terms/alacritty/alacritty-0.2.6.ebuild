# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
MacTypes-sys-1.3.0
adler32-1.0.3
advapi32-sys-0.2.0
aho-corasick-0.6.9
andrew-0.1.5
android_glue-0.2.3
ansi_term-0.11.0
approx-0.3.1
argon2rs-0.2.5
arraydeque-0.4.3
arrayvec-0.4.10
atty-0.2.11
autocfg-0.1.2
backtrace-0.3.13
backtrace-sys-0.1.28
base64-0.10.0
bindgen-0.33.2
bitflags-0.7.0
bitflags-1.0.4
blake2-rfc-0.2.18
block-0.1.6
byteorder-1.2.7
bytes-0.4.11
bzip2-0.3.3
bzip2-sys-0.1.7
cc-1.0.28
cexpr-0.2.3
cfg-if-0.1.6
cgl-0.2.3
cgmath-0.17.0
clang-sys-0.22.0
clap-2.32.0
clipboard-0.4.6
clipboard-win-2.1.2
cloudabi-0.0.3
cmake-0.1.35
cocoa-0.18.4
color_quant-1.0.1
constant_time_eq-0.1.3
copypasta-0.0.1
core-foundation-0.5.1
core-foundation-0.6.3
core-foundation-sys-0.5.1
core-foundation-sys-0.6.2
core-graphics-0.13.0
core-graphics-0.17.3
core-text-13.1.1
core-text-9.2.0
crc32fast-1.1.2
crossbeam-channel-0.3.6
crossbeam-deque-0.2.0
crossbeam-deque-0.6.3
crossbeam-epoch-0.3.1
crossbeam-epoch-0.7.0
crossbeam-utils-0.2.2
crossbeam-utils-0.6.3
deflate-0.7.19
dirs-1.0.4
dlib-0.4.1
downcast-rs-1.0.3
dtoa-0.4.3
dunce-0.1.1
either-1.5.0
embed-resource-1.1.4
encoding_rs-0.8.14
env_logger-0.5.13
env_logger-0.6.0
errno-0.2.4
errno-dragonfly-0.1.1
error-chain-0.11.0
euclid-0.19.5
euclid_macros-0.1.0
expat-sys-2.1.6
failure-0.1.5
failure_derive-0.1.5
filetime-0.2.4
fnv-1.0.6
font-0.1.0
font-loader-0.6.0
foreign-types-0.3.2
foreign-types-shared-0.1.1
freetype-rs-0.19.1
freetype-sys-0.7.1
fsevent-0.2.17
fsevent-sys-0.1.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.25
futures-cpupool-0.1.8
gcc-0.3.55
gdi32-sys-0.2.0
gif-0.10.1
gl_generator-0.10.0
gleam-0.6.8
glob-0.2.11
glutin-0.19.0
h2-0.1.15
http-0.1.14
httparse-1.3.3
humantime-1.2.0
hyper-0.12.21
hyper-tls-0.3.1
idna-0.1.5
image-0.20.1
indexmap-1.0.2
inflate-0.4.4
inotify-0.6.1
inotify-sys-0.1.3
iovec-0.1.2
itoa-0.4.3
jpeg-decoder-0.1.15
kernel32-sys-0.2.2
khronos_api-3.0.0
lazy_static-1.2.0
lazycell-1.2.1
libc-0.2.47
libflate-0.1.19
libloading-0.5.0
libz-sys-1.0.25
line_drawing-0.7.0
linked-hash-map-0.5.1
lock_api-0.1.5
log-0.4.6
lzw-0.10.0
malloc_buf-0.0.6
matches-0.1.8
memchr-1.0.2
memchr-2.1.3
memmap-0.7.0
memoffset-0.2.1
mime-0.3.13
mime_guess-2.0.0-alpha.6
mio-0.6.16
mio-anonymous-pipes-0.1.0
mio-extras-2.0.5
mio-named-pipes-0.1.6
miow-0.2.1
miow-0.3.3
named_pipe-0.3.0
native-tls-0.2.2
net2-0.2.33
nix-0.12.0
nodrop-0.1.13
nom-3.2.1
nom-4.1.1
notify-4.0.6
num-derive-0.2.3
num-integer-0.1.39
num-iter-0.1.37
num-rational-0.2.1
num-traits-0.1.43
num-traits-0.2.6
num_cpus-1.9.0
objc-0.2.5
objc-foundation-0.1.1
objc_id-0.1.1
openssl-0.10.16
openssl-probe-0.1.2
openssl-sys-0.9.40
ordered-float-0.5.2
ordered-float-1.0.1
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
png-0.12.0
podio-0.1.6
proc-macro2-0.4.25
quick-error-1.2.2
quote-0.3.15
quote-0.6.10
rand-0.4.5
rand-0.5.5
rand-0.6.4
rand_chacha-0.1.1
rand_core-0.2.2
rand_core-0.3.0
rand_hc-0.1.0
rand_isaac-0.1.1
rand_os-0.1.1
rand_pcg-0.1.1
rand_xorshift-0.1.1
rayon-1.0.3
rayon-core-1.4.1
rdrand-0.4.0
redox_syscall-0.1.50
redox_termios-0.1.1
redox_users-0.2.0
regex-0.2.11
regex-1.1.0
regex-syntax-0.5.6
regex-syntax-0.6.4
remove_dir_all-0.5.1
reqwest-0.9.8
rustc-demangle-0.1.13
rustc_version-0.2.3
rusttype-0.4.3
rusttype-0.7.3
ryu-0.2.7
same-file-1.0.4
schannel-0.1.14
scoped_threadpool-0.1.9
scopeguard-0.3.3
security-framework-0.2.1
security-framework-sys-0.2.2
semver-0.9.0
semver-parser-0.7.0
serde-1.0.85
serde_derive-1.0.85
serde_json-1.0.36
serde_urlencoded-0.5.4
serde_yaml-0.8.8
servo-fontconfig-0.4.0
servo-fontconfig-sys-4.0.7
servo-freetype-sys-4.0.5
shared_library-0.1.9
siphasher-0.2.3
slab-0.4.2
smallvec-0.6.7
smithay-client-toolkit-0.4.4
socket2-0.3.8
spsc-buffer-0.1.1
stable_deref_trait-1.1.1
static_assertions-0.3.1
stb_truetype-0.2.5
string-0.1.3
strsim-0.7.0
syn-0.15.26
synstructure-0.10.1
tempfile-3.0.5
termcolor-1.0.4
terminfo-0.6.1
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
tiff-0.2.1
time-0.1.42
tokio-0.1.14
tokio-current-thread-0.1.4
tokio-executor-0.1.6
tokio-io-0.1.11
tokio-reactor-0.1.8
tokio-tcp-0.1.3
tokio-threadpool-0.1.10
tokio-timer-0.2.8
try-lock-0.2.2
ucd-util-0.1.3
unicase-1.4.2
unicase-2.2.0
unicode-bidi-0.3.4
unicode-normalization-0.1.7
unicode-width-0.1.5
unicode-xid-0.1.0
unreachable-1.0.0
url-1.7.2
user32-sys-0.2.0
utf8-ranges-1.0.2
utf8parse-0.1.1
uuid-0.7.1
vcpkg-0.2.6
vec_map-0.8.1
version_check-0.1.5
void-1.0.2
vte-0.3.3
walkdir-2.2.7
want-0.0.6
wayland-client-0.21.10
wayland-commons-0.21.10
wayland-protocols-0.21.10
wayland-scanner-0.21.10
wayland-sys-0.21.10
which-1.0.5
widestring-0.2.2
widestring-0.4.0
winapi-0.2.8
winapi-0.3.6
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.1
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
winit-0.18.1
winpty-sys-0.4.3
winreg-0.4.0
ws2_32-sys-0.2.1
x11-clipboard-0.2.2
x11-dl-2.18.3
xcb-0.8.2
xdg-2.2.0
xml-rs-0.8.0
yaml-rust-0.4.2
zip-0.5.0
"

inherit bash-completion-r1 cargo desktop eutils

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://github.com/jwilm/alacritty"
SRC_URI="https://github.com/jwilm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~gyakovlev/distfiles/alacritty.png
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	media-libs/fontconfig:=
	media-libs/freetype:2
"

RDEPEND="${DEPEND}
	sys-libs/zlib
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXrandr
	x11-misc/xclip
	virtual/opengl
"

BDEPEND="dev-util/cmake
	sys-libs/ncurses
	>=virtual/rust-1.31.1
"

DOCS=( CHANGELOG.md docs/ansicode.txt INSTALL.md README.md alacritty.yml )

src_install() {
	cargo_src_install --path ./

	newbashcomp alacritty-completions.bash alacritty

	insinto /usr/share/fish/vendor_completions.d/
	newins alacritty-completions.fish alacritty.fish

	insinto /usr/share/zsh/site-functions
	newins alacritty-completions.zsh _alacritty

	tic -e alacritty,alacritty-direct -o "${T}" alacritty.info || die "generating terminfo failed"
	insinto /usr/share/terminfo/a/
	doins  "${T}"/a/alacritty*

	sed -i '/^Icon=/s/utilities-terminal/alacritty/' alacritty.desktop || die
	domenu alacritty.desktop
	doicon "${DISTDIR}"/alacritty.png

	newman alacritty.man alacritty.1

	einstalldocs
}

pkg_postinst() {
	optfeature "wayland support" dev-libs/wayland
}

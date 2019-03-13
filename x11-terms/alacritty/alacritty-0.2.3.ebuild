# Copyright 2017-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler32-1.0.3
advapi32-sys-0.2.0
aho-corasick-0.6.9
andrew-0.1.4
android_glue-0.2.3
ansi_term-0.11.0
approx-0.1.1
approx-0.3.0
argon2rs-0.2.5
arraydeque-0.4.3
arrayvec-0.4.7
atty-0.2.11
backtrace-0.3.9
backtrace-sys-0.1.24
base64-0.9.3
bindgen-0.33.2
bitflags-0.7.0
bitflags-0.9.1
bitflags-1.0.4
blake2-rfc-0.2.18
block-0.1.6
build_const-0.2.1
byteorder-1.2.7
bytes-0.4.10
bzip2-0.3.3
bzip2-sys-0.1.6
cc-1.0.25
cexpr-0.2.3
cfg-if-0.1.6
cgl-0.2.3
cgmath-0.16.1
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
core-foundation-0.2.3
core-foundation-0.5.1
core-foundation-0.6.3
core-foundation-sys-0.2.3
core-foundation-sys-0.5.1
core-foundation-sys-0.6.2
core-graphics-0.13.0
core-graphics-0.17.3
core-text-13.1.1
core-text-9.2.0
crc-1.8.1
crossbeam-deque-0.2.0
crossbeam-deque-0.6.2
crossbeam-epoch-0.3.1
crossbeam-epoch-0.6.1
crossbeam-utils-0.2.2
crossbeam-utils-0.5.0
crossbeam-utils-0.6.0
crossbeam-utils-0.6.1
deflate-0.7.19
dirs-1.0.4
dlib-0.4.1
downcast-rs-1.0.3
dtoa-0.4.3
dunce-0.1.1
either-1.5.0
embed-resource-1.1.4
encoding_rs-0.8.10
env_logger-0.5.13
errno-0.2.4
errno-dragonfly-0.1.1
error-chain-0.11.0
euclid-0.17.3
expat-sys-2.1.6
failure-0.1.3
failure_derive-0.1.3
filetime-0.2.3
flate2-1.0.4
fnv-1.0.6
font-0.1.0
font-loader-0.6.0
foreign-types-0.3.2
foreign-types-shared-0.1.1
freetype-rs-0.19.0
freetype-sys-0.7.0
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
gl_generator-0.9.0
gleam-0.6.6
glob-0.2.11
glutin-0.19.0
httparse-1.3.3
humantime-1.1.1
hyper-0.11.27
hyper-tls-0.1.4
idna-0.1.5
image-0.20.1
inflate-0.4.3
inotify-0.6.1
inotify-sys-0.1.3
iovec-0.1.2
itoa-0.4.3
jpeg-decoder-0.1.15
kernel32-sys-0.2.2
khronos_api-2.2.0
khronos_api-3.0.0
language-tags-0.2.2
lazy_static-0.2.11
lazy_static-1.2.0
lazycell-0.4.0
lazycell-1.2.0
libc-0.2.43
libflate-0.1.18
libloading-0.5.0
libz-sys-1.0.25
line_drawing-0.7.0
linked-hash-map-0.5.1
lock_api-0.1.4
log-0.3.9
log-0.4.6
lzw-0.10.0
malloc_buf-0.0.6
matches-0.1.8
memchr-1.0.2
memchr-2.1.1
memmap-0.6.2
memoffset-0.2.1
mime-0.3.12
mime_guess-2.0.0-alpha.6
miniz_oxide-0.2.0
miniz_oxide_c_api-0.2.0
mio-0.6.16
mio-extras-2.0.5
mio-more-0.1.0
mio-named-pipes-0.1.6
mio-uds-0.6.7
miow-0.2.1
miow-0.3.3
msdos_time-0.1.6
named_pipe-0.3.0
native-tls-0.1.5
net2-0.2.33
nix-0.11.0
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
num_cpus-1.8.0
objc-0.2.5
objc-foundation-0.1.1
objc_id-0.1.1
openssl-0.9.24
openssl-sys-0.9.39
ordered-float-0.5.2
ordered-float-1.0.1
osmesa-sys-0.1.2
owning_ref-0.3.3
parking_lot-0.6.4
parking_lot_core-0.3.1
peeking_take_while-0.1.2
percent-encoding-1.0.1
phf-0.7.23
phf_codegen-0.7.23
phf_generator-0.7.23
phf_shared-0.7.23
pkg-config-0.3.14
png-0.12.0
podio-0.1.6
proc-macro2-0.4.23
quick-error-1.2.2
quote-0.3.15
quote-0.6.10
rand-0.4.3
rand-0.5.5
rand_core-0.2.2
rand_core-0.3.0
rayon-1.0.3
rayon-core-1.4.1
redox_syscall-0.1.40
redox_termios-0.1.1
redox_users-0.2.0
regex-0.2.11
regex-1.0.6
regex-syntax-0.5.6
regex-syntax-0.6.3
relay-0.1.1
remove_dir_all-0.5.1
reqwest-0.8.8
rustc-demangle-0.1.9
rustc_version-0.2.3
rusttype-0.4.3
rusttype-0.7.2
ryu-0.2.7
safemem-0.3.0
same-file-1.0.4
schannel-0.1.14
scoped-tls-0.1.2
scoped_threadpool-0.1.9
scopeguard-0.3.3
security-framework-0.1.16
security-framework-sys-0.1.16
semver-0.9.0
semver-parser-0.7.0
serde-1.0.80
serde_derive-1.0.80
serde_json-1.0.33
serde_urlencoded-0.5.3
serde_yaml-0.8.7
servo-fontconfig-0.4.0
servo-fontconfig-sys-4.0.7
servo-freetype-sys-4.0.4
shared_library-0.1.9
siphasher-0.2.3
slab-0.3.0
slab-0.4.1
smallvec-0.6.5
smithay-client-toolkit-0.4.1
socket2-0.3.8
stable_deref_trait-1.1.1
static_assertions-0.2.5
stb_truetype-0.2.4
strsim-0.7.0
syn-0.15.20
synstructure-0.10.1
tempdir-0.3.7
termcolor-1.0.4
terminfo-0.6.1
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
tiff-0.2.1
time-0.1.40
tokio-0.1.11
tokio-codec-0.1.1
tokio-core-0.1.17
tokio-current-thread-0.1.3
tokio-executor-0.1.5
tokio-fs-0.1.4
tokio-io-0.1.10
tokio-reactor-0.1.6
tokio-service-0.1.0
tokio-tcp-0.1.2
tokio-threadpool-0.1.8
tokio-timer-0.2.7
tokio-tls-0.1.4
tokio-udp-0.1.2
tokio-uds-0.2.3
try-lock-0.1.0
ucd-util-0.1.2
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
uuid-0.6.5
vcpkg-0.2.6
vec_map-0.8.1
version_check-0.1.5
void-1.0.2
vte-0.3.3
walkdir-2.2.7
want-0.0.4
wayland-client-0.21.4
wayland-commons-0.21.4
wayland-protocols-0.21.4
wayland-scanner-0.21.4
wayland-sys-0.21.4
which-1.0.5
widestring-0.2.2
winapi-0.2.8
winapi-0.3.6
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.1
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
winit-0.18.0
winreg-0.4.0
ws2_32-sys-0.2.1
x11-clipboard-0.2.2
x11-dl-2.18.3
xcb-0.8.2
xdg-2.1.0
xml-rs-0.7.0
xml-rs-0.8.0
yaml-rust-0.4.2
zip-0.4.2
"

inherit bash-completion-r1 cargo desktop

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://github.com/jwilm/alacritty"
SRC_URI="https://github.com/jwilm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~gyakovlev/distfiles/alacritty.png
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test wayland"

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
	wayland? ( dev-libs/wayland )
"

BDEPEND="dev-util/cmake
	sys-libs/ncurses
"

DOCS=( CHANGELOG.md docs/ansicode.txt INSTALL.md README.md alacritty.yml )

PATCHES=( "${FILESDIR}/${P}-avoid-fetching-custom-windows-deps.patch" )

src_install() {
	cargo_src_install

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

src_test() {
	cargo test -j $(makeopts_jobs) $(usex debug "" --release) || die "tests failed"
}

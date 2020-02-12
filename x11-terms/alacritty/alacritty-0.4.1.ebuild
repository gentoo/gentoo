# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler32-1.0.4
aho-corasick-0.6.10
aho-corasick-0.7.6
andrew-0.2.1
android_glue-0.2.3
ansi_term-0.11.0
approx-0.3.2
arc-swap-0.4.4
arrayref-0.3.5
arrayvec-0.5.1
atty-0.2.13
autocfg-0.1.7
backtrace-0.3.40
backtrace-sys-0.1.32
base64-0.10.1
base64-0.11.0
bindgen-0.33.2
bitflags-1.2.1
blake2b_simd-0.5.9
block-0.1.6
byteorder-1.3.2
bzip2-0.3.3
bzip2-sys-0.1.7
c2-chacha-0.2.3
calloop-0.4.4
cc-1.0.48
cexpr-0.2.3
cfg-if-0.1.10
cgl-0.3.2
clang-sys-0.22.0
clap-2.33.0
clipboard-win-2.2.0
cloudabi-0.0.3
cmake-0.1.42
cocoa-0.19.1
constant_time_eq-0.1.4
copypasta-0.6.1
core-foundation-0.6.4
core-foundation-sys-0.6.2
core-graphics-0.17.3
core-text-13.3.2
core-video-sys-0.1.3
crc32fast-1.2.0
crossbeam-utils-0.6.6
deflate-0.7.20
dirs-2.0.2
dirs-sys-0.3.4
dispatch-0.1.4
dlib-0.4.1
downcast-rs-1.1.1
dtoa-0.4.4
dwrote-0.9.0
embed-resource-1.3.1
env_logger-0.5.13
env_logger-0.7.1
euclid-0.20.7
expat-sys-2.1.6
failure-0.1.6
failure_derive-0.1.6
filetime-0.2.8
flate2-1.0.13
fnv-1.0.6
font-0.1.0
foreign-types-0.3.2
foreign-types-0.5.0
foreign-types-macros-0.2.0
foreign-types-shared-0.1.1
foreign-types-shared-0.3.0
freetype-rs-0.23.0
freetype-sys-0.9.0
fsevent-0.4.0
fsevent-sys-2.0.1
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
getrandom-0.1.13
gl_generator-0.11.0
gl_generator-0.13.1
gl_generator-0.14.0
glob-0.2.11
glutin-0.22.0
glutin_egl_sys-0.1.4
glutin_emscripten_sys-0.1.0
glutin_gles2_sys-0.1.3
glutin_glx_sys-0.1.5
glutin_wgl_sys-0.1.3
hermit-abi-0.1.6
http_req-0.5.4
humantime-1.3.0
idna-0.2.0
image-0.22.3
inflate-0.4.5
inotify-0.6.1
inotify-sys-0.1.3
instant-0.1.2
iovec-0.1.4
itoa-0.4.4
jobserver-0.1.17
kernel32-sys-0.2.2
khronos_api-3.1.0
lazy_static-1.4.0
lazycell-1.2.1
libc-0.2.66
libloading-0.5.2
libz-sys-1.0.25
line_drawing-0.7.0
linked-hash-map-0.5.2
lock_api-0.3.3
log-0.4.8
malloc_buf-0.0.6
matches-0.1.8
maybe-uninit-2.0.0
memchr-1.0.2
memchr-2.2.1
memmap-0.7.0
miniz_oxide-0.3.5
mio-0.6.21
mio-anonymous-pipes-0.1.0
mio-extras-2.0.6
mio-named-pipes-0.1.6
miow-0.2.1
miow-0.3.3
named_pipe-0.4.1
native-tls-0.2.3
net2-0.2.33
nix-0.14.1
nix-0.15.0
nom-3.2.1
nom-4.2.3
notify-4.0.14
num-integer-0.1.41
num-iter-0.1.39
num-rational-0.2.2
num-traits-0.2.10
num_cpus-1.11.1
objc-0.2.7
objc-foundation-0.1.1
objc_id-0.1.1
openssl-0.10.26
openssl-probe-0.1.2
openssl-sys-0.9.53
ordered-float-1.0.2
osmesa-sys-0.1.2
parking_lot-0.10.0
parking_lot-0.9.0
parking_lot_core-0.6.2
parking_lot_core-0.7.0
peeking_take_while-0.1.2
percent-encoding-2.1.0
phf-0.7.24
phf_codegen-0.7.24
phf_generator-0.7.24
phf_shared-0.7.24
pkg-config-0.3.17
png-0.15.2
podio-0.1.6
ppv-lite86-0.2.6
proc-macro2-0.4.30
proc-macro2-1.0.7
quick-error-1.2.3
quote-0.3.15
quote-0.6.13
quote-1.0.2
rand-0.6.5
rand-0.7.2
rand_chacha-0.1.1
rand_chacha-0.2.1
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_hc-0.1.0
rand_hc-0.2.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
raw-window-handle-0.3.3
rdrand-0.4.0
redox_syscall-0.1.56
redox_users-0.3.1
regex-0.2.11
regex-1.3.1
regex-syntax-0.5.6
regex-syntax-0.6.12
remove_dir_all-0.5.2
rust-argon2-0.5.1
rustc-demangle-0.1.16
rustc_tools_util-0.2.0
rustc_version-0.2.3
rusttype-0.7.9
rusttype-0.8.2
ryu-1.0.2
same-file-1.0.5
schannel-0.1.16
scopeguard-1.0.0
security-framework-0.3.4
security-framework-sys-0.3.3
semver-0.9.0
semver-parser-0.7.0
serde-1.0.104
serde_derive-1.0.104
serde_json-1.0.44
serde_yaml-0.8.11
servo-fontconfig-0.4.0
servo-fontconfig-sys-4.0.9
servo-freetype-sys-4.0.3
shared_library-0.1.9
signal-hook-0.1.12
signal-hook-registry-1.2.0
siphasher-0.2.3
slab-0.4.2
smallvec-0.6.13
smallvec-1.1.0
smithay-client-toolkit-0.6.4
smithay-clipboard-0.3.6
socket2-0.3.11
spsc-buffer-0.1.1
stb_truetype-0.3.1
strsim-0.8.0
syn-1.0.13
synstructure-0.12.3
tempfile-3.1.0
termcolor-1.0.5
terminfo-0.6.1
textwrap-0.11.0
thread_local-0.3.6
time-0.1.42
ucd-util-0.1.5
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.11
unicode-width-0.1.7
unicode-xid-0.1.0
unicode-xid-0.2.0
url-2.1.0
urlocator-0.1.2
utf8-ranges-1.0.4
utf8parse-0.1.1
vcpkg-0.2.8
vec_map-0.8.1
version_check-0.1.5
version_check-0.9.1
void-1.0.2
vswhom-0.1.0
vswhom-sys-0.1.0
vte-0.3.3
walkdir-2.2.9
wasi-0.7.0
wayland-client-0.23.6
wayland-commons-0.23.6
wayland-protocols-0.23.6
wayland-scanner-0.23.6
wayland-sys-0.23.6
which-1.0.5
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.2
winit-0.20.0
winpty-sys-0.4.3
winreg-0.6.2
ws2_32-sys-0.2.1
x11-clipboard-0.4.0
x11-dl-2.18.4
xcb-0.9.0
xdg-2.2.0
xml-rs-0.8.0
yaml-rust-0.4.3
zip-0.5.3
"

MY_PV="${PV//_rc/-rc}"

inherit bash-completion-r1 cargo desktop eutils

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://github.com/jwilm/alacritty"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jwilm/alacritty"
else
	SRC_URI="https://github.com/jwilm/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 BSD BSD-2 CC0-1.0 FTL ISC MIT MPL-2.0 Unlicense WTFPL-2 ZLIB"
SLOT="0"
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
	>=virtual/rust-1.37.0
"

DOCS=( CHANGELOG.md docs/ansicode.txt INSTALL.md README.md alacritty.yml )

QA_FLAGS_IGNORED="usr/bin/alacritty"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( "${FILESDIR}/${P}-fix-winit.patch" )

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	[[ "${PV}" == *9999* ]] || ln -s ../alacritty_git_deps "${ECARGO_HOME}"/git
	default
}

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

src_test() {
	cargo_src_test --offline
}

pkg_postinst() {
	optfeature "wayland support" dev-libs/wayland
	optfeature "apply-tilix-colorscheme script dependency" dev-python/pyyaml
}

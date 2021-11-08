# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ab_glyph_rasterizer-0.1.4
adler32-1.2.0
andrew-0.3.1
android_glue-0.2.3
ansi_term-0.11.0
atty-0.2.14
autocfg-1.0.1
base64-0.13.0
bitflags-1.2.1
block-0.1.6
calloop-0.6.5
cc-1.0.69
cfg-if-0.1.10
cfg-if-1.0.0
cgl-0.3.2
clap-2.33.3
clipboard-win-3.1.1
cmake-0.1.45
cocoa-0.23.0
cocoa-0.24.0
cocoa-foundation-0.1.0
copypasta-0.7.1
core-foundation-0.7.0
core-foundation-0.9.1
core-foundation-sys-0.7.0
core-foundation-sys-0.8.2
core-graphics-0.19.2
core-graphics-0.22.2
core-graphics-types-0.1.1
core-text-19.2.0
core-video-sys-0.1.4
crc32fast-1.2.1
crossfont-0.3.1
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
derivative-2.2.0
dirs-3.0.2
dirs-sys-0.3.6
dispatch-0.2.0
dlib-0.4.2
dlib-0.5.0
downcast-rs-1.2.0
dtoa-0.4.8
dwrote-0.11.0
embed-resource-1.6.3
expat-sys-2.1.6
filetime-0.2.14
fnv-1.0.7
foreign-types-0.3.2
foreign-types-0.5.0
foreign-types-macros-0.2.1
foreign-types-shared-0.1.1
foreign-types-shared-0.3.0
freetype-rs-0.26.0
freetype-sys-0.13.1
fsevent-0.4.0
fsevent-sys-2.0.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
getrandom-0.2.3
gl_generator-0.14.0
glutin-0.26.0
glutin_egl_sys-0.1.5
glutin_emscripten_sys-0.1.1
glutin_gles2_sys-0.1.5
glutin_glx_sys-0.1.7
glutin_wgl_sys-0.1.5
hermit-abi-0.1.19
ident_case-1.0.1
inotify-0.7.1
inotify-sys-0.1.5
instant-0.1.10
iovec-0.1.4
itoa-0.4.7
jni-sys-0.3.0
kernel32-sys-0.2.2
khronos_api-3.1.0
lazy-bytes-cast-5.0.1
lazycell-1.3.0
lazy_static-1.4.0
libc-0.2.98
libloading-0.6.7
libloading-0.7.0
linked-hash-map-0.5.4
lock_api-0.4.4
log-0.4.14
malloc_buf-0.0.6
maybe-uninit-2.0.0
memchr-2.3.4
memmap2-0.1.0
memmap2-0.2.3
memoffset-0.6.4
miniz_oxide-0.3.7
mio-0.6.23
mio-anonymous-pipes-0.2.0
mio-extras-2.0.6
miow-0.2.2
miow-0.3.7
ndk-0.2.1
ndk-glue-0.2.1
ndk-macro-0.2.0
ndk-sys-0.2.1
net2-0.2.37
nix-0.18.0
nix-0.20.0
nix-0.22.0
nom-6.2.1
notify-4.0.17
num_enum-0.4.3
num_enum_derive-0.4.3
objc-0.2.7
objc-foundation-0.1.1
objc_id-0.1.1
once_cell-1.8.0
osmesa-sys-0.1.2
owned_ttf_parser-0.6.0
parking_lot-0.11.1
parking_lot_core-0.8.3
percent-encoding-2.1.0
pkg-config-0.3.19
png-0.16.8
proc-macro2-1.0.28
proc-macro-crate-0.1.5
quote-1.0.9
raw-window-handle-0.3.3
redox_syscall-0.2.9
redox_users-0.4.0
regex-automata-0.1.10
regex-syntax-0.6.25
rusttype-0.9.2
ryu-1.0.5
same-file-1.0.6
scoped-tls-1.0.0
scopeguard-1.1.0
serde-1.0.127
serde_derive-1.0.127
serde_json-1.0.66
serde_yaml-0.8.17
servo-fontconfig-0.5.1
servo-fontconfig-sys-5.1.0
shared_library-0.1.9
signal-hook-0.1.17
signal-hook-registry-1.4.0
slab-0.4.3
smallvec-1.6.1
smithay-client-toolkit-0.12.3
smithay-client-toolkit-0.14.0
smithay-clipboard-0.6.4
spsc-buffer-0.1.1
strsim-0.8.0
strsim-0.9.3
syn-1.0.74
textwrap-0.11.0
thiserror-1.0.26
thiserror-impl-1.0.26
time-0.1.43
toml-0.5.8
ttf-parser-0.6.2
unicode-width-0.1.8
unicode-xid-0.2.2
utf8parse-0.2.0
vec_map-0.8.2
version_check-0.9.3
vswhom-0.1.0
vswhom-sys-0.1.0
vte-0.10.1
vte_generate_state_changes-0.1.1
walkdir-2.3.2
wasi-0.10.2+wasi-snapshot-preview1
wayland-client-0.28.6
wayland-commons-0.28.6
wayland-cursor-0.28.6
wayland-egl-0.28.6
wayland-protocols-0.28.6
wayland-scanner-0.28.6
wayland-sys-0.28.6
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winit-0.24.0
winreg-0.9.0
wio-0.2.2
ws2_32-sys-0.2.1
x11-clipboard-0.5.2
x11-dl-2.18.5
xcb-0.9.0
xcursor-0.3.3
xdg-2.2.0
xml-rs-0.8.4
yaml-rust-0.4.5
"

MY_PV="${PV//_rc/-rc}"
# https://bugs.gentoo.org/725962
PYTHON_COMPAT=( python3_{7,8,9} )

inherit bash-completion-r1 cargo desktop python-any-r1

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://github.com/alacritty/alacritty"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alacritty/alacritty"
else
	SRC_URI="https://github.com/alacritty/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
	KEYWORDS="amd64 ~arm64 ppc64 ~x86"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 BSD BSD-2 CC0-1.0 FTL ISC MIT MPL-2.0 Unlicense WTFPL-2 ZLIB"
SLOT="0"
IUSE="wayland +X"

REQUIRED_USE="|| ( wayland X )"

DEPEND="${PYTHON_DEPS}"

COMMON_DEPEND="
	media-libs/fontconfig:=
	media-libs/freetype:2
	X? ( x11-libs/libxcb:=[xkb] )
"

RDEPEND="${COMMON_DEPEND}
	media-libs/mesa[X?,wayland?]
	sys-libs/zlib
	sys-libs/ncurses:0
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXrandr
	)
"

BDEPEND="dev-util/cmake"

QA_FLAGS_IGNORED="usr/bin/alacritty"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	local myfeatures=(
		$(usex X x11 '')
		$(usev wayland)
	)
	cargo_src_configure --no-default-features
}

src_compile() {
	cd alacritty || die
	cargo_src_compile
}

src_install() {
	cargo_src_install --path alacritty

	newman extra/alacritty.man alacritty.1

	newbashcomp extra/completions/alacritty.bash alacritty

	insinto /usr/share/fish/vendor_completions.d/
	doins extra/completions/alacritty.fish

	insinto /usr/share/zsh/site-functions
	doins extra/completions/_alacritty

	domenu extra/linux/Alacritty.desktop
	newicon extra/logo/compat/alacritty-term.svg Alacritty.svg

	newman extra/alacritty.man alacritty.1

	insinto /usr/share/metainfo
	doins extra/linux/io.alacritty.Alacritty.appdata.xml

	insinto /usr/share/alacritty/scripts
	doins -r scripts/*

	local DOCS=(
		alacritty.yml
		CHANGELOG.md INSTALL.md README.md
		docs/{ansicode.txt,escape_support.md,features.md}
	)
	einstalldocs
}

src_test() {
	cd alacritty || die
	cargo_src_test
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		einfo "Configuration files for ${CATEGORY}/${PN}"
		einfo "in \$HOME often need to be updated after a version change"
		einfo ""
		einfo "An up-to-date sample configuration file always can be found at"
		einfo "${ROOT}/usr/share/doc/${PF}/alacritty.yml.*"
	fi
}

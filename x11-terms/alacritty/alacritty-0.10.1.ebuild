# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler32-1.2.0
	android_glue-0.2.3
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.0.1
	base64-0.13.0
	bitflags-1.2.1
	block-0.1.6
	bumpalo-3.9.1
	calloop-0.9.3
	cc-1.0.72
	cfg-if-0.1.10
	cfg-if-1.0.0
	cgl-0.3.2
	clap-2.34.0
	clipboard-win-3.1.1
	cmake-0.1.48
	cocoa-0.24.0
	cocoa-foundation-0.1.0
	copypasta-0.7.1
	core-foundation-0.7.0
	core-foundation-0.9.2
	core-foundation-sys-0.7.0
	core-foundation-sys-0.8.3
	core-graphics-0.19.2
	core-graphics-0.22.3
	core-graphics-types-0.1.1
	core-text-19.2.0
	core-video-sys-0.1.4
	crc32fast-1.3.0
	crossfont-0.3.2
	cty-0.2.2
	darling-0.13.1
	darling_core-0.13.1
	darling_macro-0.13.1
	dirs-3.0.2
	dirs-sys-0.3.6
	dispatch-0.2.0
	dlib-0.5.0
	downcast-rs-1.2.0
	dwrote-0.11.0
	embed-resource-1.6.5
	expat-sys-2.1.6
	filetime-0.2.15
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
	glutin-0.28.0
	glutin_egl_sys-0.1.5
	glutin_emscripten_sys-0.1.1
	glutin_gles2_sys-0.1.5
	glutin_glx_sys-0.1.7
	glutin_wgl_sys-0.1.5
	hashbrown-0.11.2
	heck-0.3.3
	hermit-abi-0.1.19
	ident_case-1.0.1
	indexmap-1.8.0
	inotify-0.7.1
	inotify-sys-0.1.5
	instant-0.1.12
	iovec-0.1.4
	itoa-1.0.1
	jni-sys-0.3.0
	js-sys-0.3.55
	kernel32-sys-0.2.2
	khronos_api-3.1.0
	lazy-bytes-cast-5.0.1
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.112
	libloading-0.7.2
	linked-hash-map-0.5.4
	lock_api-0.4.5
	log-0.4.14
	malloc_buf-0.0.6
	memchr-2.4.1
	memmap2-0.3.1
	memoffset-0.6.5
	minimal-lexical-0.2.1
	miniz_oxide-0.3.7
	mio-0.6.23
	mio-0.8.0
	mio-anonymous-pipes-0.2.0
	mio-extras-2.0.6
	mio-uds-0.6.8
	miow-0.2.2
	miow-0.3.7
	ndk-0.5.0
	ndk-glue-0.5.0
	ndk-macro-0.3.0
	ndk-sys-0.2.2
	net2-0.2.37
	nix-0.22.2
	nom-7.1.0
	notify-4.0.17
	ntapi-0.3.6
	num_enum-0.5.6
	num_enum_derive-0.5.6
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	once_cell-1.9.0
	osmesa-sys-0.1.2
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	percent-encoding-2.1.0
	pkg-config-0.3.24
	png-0.16.8
	proc-macro-crate-1.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.36
	quick-xml-0.22.0
	quote-1.0.14
	raw-window-handle-0.4.2
	redox_syscall-0.2.10
	redox_users-0.4.0
	regex-automata-0.1.10
	regex-syntax-0.6.25
	ryu-1.0.9
	same-file-1.0.6
	scoped-tls-1.0.0
	scopeguard-1.1.0
	serde-1.0.133
	serde_derive-1.0.133
	serde_json-1.0.74
	serde_yaml-0.8.23
	servo-fontconfig-0.5.1
	servo-fontconfig-sys-5.1.0
	shared_library-0.1.9
	signal-hook-0.3.13
	signal-hook-mio-0.2.1
	signal-hook-registry-1.4.0
	slab-0.4.5
	smallvec-1.7.0
	smithay-client-toolkit-0.15.3
	smithay-clipboard-0.6.5
	spsc-buffer-0.1.1
	strsim-0.8.0
	strsim-0.10.0
	structopt-0.3.25
	structopt-derive-0.4.18
	syn-1.0.85
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	toml-0.5.8
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	utf8parse-0.2.0
	vec_map-0.8.2
	version_check-0.9.4
	vswhom-0.1.0
	vswhom-sys-0.1.0
	vte-0.10.1
	vte_generate_state_changes-0.1.1
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.78
	wasm-bindgen-backend-0.2.78
	wasm-bindgen-macro-0.2.78
	wasm-bindgen-macro-support-0.2.78
	wasm-bindgen-shared-0.2.78
	wayland-client-0.29.4
	wayland-commons-0.29.4
	wayland-cursor-0.29.4
	wayland-egl-0.29.4
	wayland-protocols-0.29.4
	wayland-scanner-0.29.4
	wayland-sys-0.29.4
	web-sys-0.3.55
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	winit-0.26.1
	winreg-0.10.1
	wio-0.2.2
	ws2_32-sys-0.2.1
	x11-clipboard-0.5.3
	x11-dl-2.19.1
	xcb-0.10.1
	xcursor-0.3.4
	xdg-2.4.0
	xml-rs-0.8.4
	yaml-rust-0.4.5
"

MY_PV="${PV//_rc/-rc}"
# https://bugs.gentoo.org/725962
PYTHON_COMPAT=( python3_{7..10} )

inherit bash-completion-r1 cargo desktop python-any-r1

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://github.com/alacritty/alacritty"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alacritty/alacritty"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
	KEYWORDS="amd64 arm64 ppc64 ~riscv x86"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 BSD BSD-2 CC0-1.0 FTL ISC MIT MPL-2.0 Unlicense WTFPL-2 ZLIB"
SLOT="0"
IUSE="wayland +X"

REQUIRED_USE="|| ( wayland X )"

COMMON_DEPEND="
	media-libs/fontconfig:=
	media-libs/freetype:2
	x11-libs/libxkbcommon
	X? ( x11-libs/libxcb:=[xkb] )
"

DEPEND="
	${COMMON_DEPEND}
	${PYTHON_DEPS}
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

BDEPEND="
	dev-util/cmake
	>=virtual/rust-1.53.0
"

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
	newman extra/alacritty-msg.man alacritty-msg.1

	newbashcomp extra/completions/alacritty.bash alacritty

	insinto /usr/share/fish/vendor_completions.d/
	doins extra/completions/alacritty.fish

	insinto /usr/share/zsh/site-functions
	doins extra/completions/_alacritty

	domenu extra/linux/Alacritty.desktop
	newicon extra/logo/compat/alacritty-term.svg Alacritty.svg

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

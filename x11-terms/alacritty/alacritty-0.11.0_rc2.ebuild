# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	arrayref-0.3.6
	arrayvec-0.5.2
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	block-0.1.6
	bumpalo-3.11.0
	bytemuck-1.12.1
	calloop-0.10.1
	cc-1.0.73
	cfg-if-0.1.10
	cfg-if-1.0.0
	cgl-0.3.2
	clap-3.2.21
	clap_complete-3.2.5
	clap_derive-3.2.18
	clap_lex-0.2.4
	clipboard-win-3.1.1
	cmake-0.1.48
	cocoa-0.24.0
	cocoa-foundation-0.1.0
	copypasta-0.8.1
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	core-graphics-0.22.3
	core-graphics-types-0.1.1
	core-text-19.2.0
	crc32fast-1.3.2
	crossfont-0.5.0
	cty-0.2.2
	darling-0.13.4
	darling_core-0.13.4
	darling_macro-0.13.4
	dirs-4.0.0
	dirs-sys-0.3.7
	dispatch-0.2.0
	dlib-0.5.0
	downcast-rs-1.2.0
	dwrote-0.11.0
	embed-resource-1.7.3
	expat-sys-2.1.6
	filetime-0.2.17
	flate2-1.0.24
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-0.5.0
	foreign-types-macros-0.2.2
	foreign-types-shared-0.1.1
	foreign-types-shared-0.3.1
	freetype-rs-0.26.0
	freetype-sys-0.13.1
	fsevent-0.4.0
	fsevent-sys-2.0.1
	fuchsia-zircon-0.3.3
	fuchsia-zircon-sys-0.3.3
	getrandom-0.2.7
	gl_generator-0.14.0
	glutin-0.29.1
	glutin_egl_sys-0.1.6
	glutin_gles2_sys-0.1.5
	glutin_glx_sys-0.1.8
	glutin_wgl_sys-0.1.5
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	ident_case-1.0.1
	indexmap-1.9.1
	inotify-0.7.1
	inotify-sys-0.1.5
	instant-0.1.12
	iovec-0.1.4
	itoa-1.0.3
	jni-sys-0.3.0
	js-sys-0.3.60
	kernel32-sys-0.2.2
	khronos_api-3.1.0
	lazy-bytes-cast-5.0.1
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.132
	libloading-0.7.3
	linked-hash-map-0.5.6
	lock_api-0.4.8
	log-0.4.17
	malloc_buf-0.0.6
	memchr-2.5.0
	memmap2-0.5.7
	memoffset-0.6.5
	minimal-lexical-0.2.1
	miniz_oxide-0.5.4
	mio-0.6.23
	mio-0.8.4
	mio-anonymous-pipes-0.2.0
	mio-extras-2.0.6
	mio-uds-0.6.8
	miow-0.2.2
	miow-0.3.7
	ndk-0.7.0
	ndk-context-0.1.1
	ndk-glue-0.7.0
	ndk-macro-0.3.0
	ndk-sys-0.4.0
	net2-0.2.37
	nix-0.24.2
	nom-7.1.1
	notify-4.0.17
	num_enum-0.5.7
	num_enum_derive-0.5.7
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	once_cell-1.14.0
	os_str_bytes-6.3.0
	osmesa-sys-0.1.2
	parking_lot-0.11.2
	parking_lot-0.12.1
	parking_lot_core-0.8.5
	parking_lot_core-0.9.3
	percent-encoding-2.2.0
	pkg-config-0.3.25
	png-0.17.6
	proc-macro-crate-1.2.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.43
	quick-xml-0.22.0
	quote-1.0.21
	raw-window-handle-0.4.3
	raw-window-handle-0.5.0
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-automata-0.1.10
	regex-syntax-0.6.27
	rustc_version-0.4.0
	ryu-1.0.11
	safe_arch-0.5.2
	same-file-1.0.6
	scoped-tls-1.0.0
	scopeguard-1.1.0
	sctk-adwaita-0.4.2
	semver-1.0.14
	serde-1.0.144
	serde_derive-1.0.144
	serde_json-1.0.85
	serde_yaml-0.8.26
	servo-fontconfig-0.5.1
	servo-fontconfig-sys-5.1.0
	shared_library-0.1.9
	signal-hook-0.3.14
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.0
	slab-0.4.7
	slotmap-1.0.6
	smallvec-1.9.0
	smithay-client-toolkit-0.16.0
	smithay-clipboard-0.6.6
	spsc-buffer-0.1.1
	strsim-0.10.0
	syn-1.0.99
	termcolor-1.1.3
	textwrap-0.15.1
	thiserror-1.0.35
	thiserror-impl-1.0.35
	tiny-skia-0.7.0
	tiny-skia-path-0.7.0
	toml-0.5.8
	unicode-ident-1.0.4
	unicode-width-0.1.10
	utf8parse-0.2.0
	vec_map-0.8.2
	version_check-0.9.4
	vswhom-0.1.0
	vswhom-sys-0.1.1
	vte-0.10.1
	vte_generate_state_changes-0.1.1
	walkdir-2.3.2
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	wayland-client-0.29.5
	wayland-commons-0.29.5
	wayland-cursor-0.29.5
	wayland-egl-0.29.5
	wayland-protocols-0.29.5
	wayland-scanner-0.29.5
	wayland-sys-0.29.5
	web-sys-0.3.60
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	winit-0.27.3
	winreg-0.10.1
	wio-0.2.2
	ws2_32-sys-0.2.1
	x11-clipboard-0.6.1
	x11-dl-2.20.0
	xcb-1.1.1
	xcursor-0.3.4
	xdg-2.4.1
	xml-rs-0.8.4
	yaml-rust-0.4.5
"

MY_PV="${PV//_rc/-rc}"
# https://bugs.gentoo.org/725962
PYTHON_COMPAT=( python3_{8..11} )

inherit bash-completion-r1 cargo desktop python-any-r1

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://alacritty.org"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alacritty/alacritty"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
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
	>=virtual/rust-1.57.0
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
	doins extra/linux/org.alacritty.Alacritty.appdata.xml

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

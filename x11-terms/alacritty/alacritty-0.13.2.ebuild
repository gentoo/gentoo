# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	ahash@0.8.11
	aho-corasick@1.1.2
	android-activity@0.5.2
	android-properties@0.2.2
	anstream@0.6.13
	anstyle-parse@0.2.3
	anstyle-query@1.0.0
	anstyle-wincon@3.0.1
	anstyle@1.0.6
	arrayref@0.3.7
	arrayvec@0.7.4
	as-raw-xcb-connection@1.0.1
	atomic-waker@1.1.2
	autocfg@1.1.0
	base64@0.22.0
	bitflags@1.3.2
	bitflags@2.4.2
	block-sys@0.2.1
	block2@0.3.0
	block@0.1.6
	bumpalo@3.15.4
	bytemuck@1.15.0
	bytes@1.5.0
	calloop-wayland-source@0.2.0
	calloop@0.12.4
	cc@1.0.90
	cesu8@1.1.0
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	cgl@0.3.2
	clap@4.4.11
	clap_builder@4.4.11
	clap_complete@4.4.4
	clap_derive@4.4.7
	clap_lex@0.6.0
	clipboard-win@3.1.1
	cmake@0.1.50
	cocoa-foundation@0.1.2
	cocoa@0.25.0
	colorchoice@1.0.0
	combine@4.6.6
	concurrent-queue@2.4.0
	copypasta@0.10.1
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	core-graphics-types@0.1.3
	core-graphics@0.23.1
	core-text@20.1.0
	crc32fast@1.4.0
	crossbeam-channel@0.5.12
	crossbeam-utils@0.8.19
	crossfont@0.7.0
	cursor-icon@1.1.0
	dirs-sys@0.4.1
	dirs@5.0.1
	dispatch@0.2.0
	dlib@0.5.2
	downcast-rs@1.2.0
	dwrote@0.11.0
	embed-resource@2.4.2
	equivalent@1.0.1
	errno@0.3.7
	expat-sys@2.1.6
	fastrand@2.0.1
	fdeflate@0.3.4
	filetime@0.2.22
	flate2@1.0.28
	foreign-types-macros@0.2.3
	foreign-types-shared@0.3.1
	foreign-types@0.5.0
	freetype-rs@0.26.0
	freetype-sys@0.13.1
	fsevent-sys@4.1.0
	futures-io@0.3.30
	gethostname@0.4.3
	getrandom@0.2.12
	gl_generator@0.14.0
	glutin@0.31.3
	glutin_egl_sys@0.6.0
	glutin_glx_sys@0.5.0
	glutin_wgl_sys@0.5.0
	hashbrown@0.14.3
	heck@0.4.1
	home@0.5.5
	icrate@0.0.4
	indexmap@2.2.5
	inotify-sys@0.1.5
	inotify@0.9.6
	itoa@1.0.10
	jni-sys@0.3.0
	jni@0.21.1
	jobserver@0.1.28
	js-sys@0.3.69
	khronos_api@3.1.0
	kqueue-sys@1.0.4
	kqueue@1.0.8
	lazy-bytes-cast@5.0.1
	lazy_static@1.4.0
	libc@0.2.153
	libloading@0.8.3
	libredox@0.0.1
	libredox@0.0.2
	linux-raw-sys@0.4.13
	lock_api@0.4.11
	log@0.4.21
	malloc_buf@0.0.6
	memchr@2.7.1
	memmap2@0.9.4
	miniz_oxide@0.7.2
	mio@0.8.11
	miow@0.6.0
	ndk-context@0.1.1
	ndk-sys@0.5.0+25.2.9519653
	ndk@0.8.0
	notify@6.1.1
	num_enum@0.7.2
	num_enum_derive@0.7.2
	objc-foundation@0.1.1
	objc-sys@0.3.2
	objc2-encode@3.0.0
	objc2@0.4.1
	objc@0.2.7
	objc_id@0.1.1
	once_cell@1.19.0
	option-ext@0.2.0
	orbclient@0.3.47
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	percent-encoding@2.3.1
	pin-project-lite@0.2.13
	piper@0.2.1
	pkg-config@0.3.30
	png@0.17.13
	polling@3.3.0
	proc-macro-crate@3.1.0
	proc-macro2@1.0.79
	quick-xml@0.31.0
	quote@1.0.35
	raw-window-handle@0.5.2
	redox_syscall@0.3.5
	redox_syscall@0.4.1
	redox_users@0.4.4
	regex-automata@0.4.6
	regex-syntax@0.8.2
	rustc_version@0.4.0
	rustix-openpty@0.1.1
	rustix@0.38.25
	ryu@1.0.17
	same-file@1.0.6
	scoped-tls@1.0.1
	scopeguard@1.2.0
	sctk-adwaita@0.8.1
	semver@1.0.22
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	serde_spanned@0.6.5
	serde_yaml@0.9.33
	servo-fontconfig-sys@5.1.0
	servo-fontconfig@0.5.1
	signal-hook-registry@1.4.1
	signal-hook@0.3.17
	simd-adler32@0.3.7
	slab@0.4.9
	smallvec@1.13.1
	smithay-client-toolkit@0.18.1
	smithay-clipboard@0.7.1
	smol_str@0.2.1
	strict-num@0.1.1
	strsim@0.10.0
	syn@2.0.53
	thiserror-impl@1.0.58
	thiserror@1.0.58
	tiny-skia-path@0.11.4
	tiny-skia@0.11.4
	toml@0.8.11
	toml_datetime@0.6.5
	toml_edit@0.21.1
	toml_edit@0.22.7
	tracing-core@0.1.32
	tracing@0.1.40
	unicode-ident@1.0.12
	unicode-segmentation@1.11.0
	unicode-width@0.1.11
	unsafe-libyaml@0.2.11
	utf8parse@0.2.1
	version_check@0.9.4
	vswhom-sys@0.1.2
	vswhom@0.1.0
	vte@0.13.0
	vte_generate_state_changes@0.1.1
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	wayland-backend@0.3.3
	wayland-client@0.31.2
	wayland-csd-frame@0.3.0
	wayland-cursor@0.31.1
	wayland-protocols-plasma@0.2.0
	wayland-protocols-wlr@0.2.0
	wayland-protocols@0.31.2
	wayland-scanner@0.31.1
	wayland-sys@0.31.1
	web-sys@0.3.69
	web-time@0.2.4
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	winit@0.29.15
	winnow@0.5.40
	winnow@0.6.5
	winreg@0.52.0
	wio@0.2.2
	x11-clipboard@0.9.2
	x11-dl@2.21.0
	x11rb-protocol@0.13.0
	x11rb@0.13.0
	xcursor@0.3.5
	xdg@2.5.2
	xkbcommon-dl@0.4.2
	xkeysym@0.2.0
	xml-rs@0.8.19
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
"

MY_PV="${PV//_rc/-rc}"

inherit bash-completion-r1 cargo desktop

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://alacritty.org"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alacritty/alacritty"
else
	SRC_URI="
		https://github.com/${PN}/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}
	"
	KEYWORDS="amd64 arm64 ppc64 ~riscv x86"
fi

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0
	Unicode-DFS-2016
"
SLOT="0"
IUSE="wayland +X"

REQUIRED_USE="|| ( wayland X )"

COMMON_DEPEND="
	media-libs/fontconfig:=
	media-libs/freetype:2
	x11-libs/libxkbcommon
	X? ( x11-libs/libxcb:= )
"

DEPEND="
	${COMMON_DEPEND}
"

RDEPEND="
	${COMMON_DEPEND}
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
	dev-build/cmake
	>=virtual/rust-1.70.0
	app-text/scdoc
"

QA_FLAGS_IGNORED="usr/bin/alacritty"

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
	scdoc < ./extra/man/alacritty.1.scd > ./alacritty.1 || die
	scdoc < ./extra/man/alacritty.5.scd > ./alacritty.5 || die
	scdoc < ./extra/man/alacritty-msg.1.scd > ./alacritty-msg.1 || die
	scdoc < ./extra/man/alacritty-bindings.5.scd > ./alacritty-bindings.5 || die

	cd alacritty || die
	cargo_src_compile
}

src_install() {
	cargo_src_install --path alacritty

	doman alacritty.1 alacritty.5 alacritty-msg.1 alacritty-bindings.5

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
		CHANGELOG.md README.md
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
		einfo "For information on how to configure alacritty, see the manpage:"
		einfo "man 5 alacritty"
	fi
}

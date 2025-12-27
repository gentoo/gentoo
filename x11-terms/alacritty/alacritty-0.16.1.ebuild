# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.1
	ahash@0.8.12
	aho-corasick@1.1.3
	android-activity@0.6.0
	android-properties@0.2.2
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.13
	arrayref@0.3.9
	arrayvec@0.7.6
	as-raw-xcb-connection@1.0.1
	atomic-waker@1.1.2
	base64@0.22.1
	bitflags@1.3.2
	bitflags@2.9.4
	block2@0.5.1
	bumpalo@3.19.0
	bytemuck@1.24.0
	bytes@1.10.1
	calloop-wayland-source@0.3.0
	calloop@0.13.0
	cc@1.2.40
	cesu8@1.1.0
	cfg-if@1.0.3
	cfg_aliases@0.2.1
	cgl@0.3.2
	clap@4.5.48
	clap_builder@4.5.48
	clap_complete@4.5.58
	clap_derive@4.5.47
	clap_lex@0.7.5
	clipboard-win@5.4.1
	colorchoice@1.0.4
	combine@4.6.7
	concurrent-queue@2.5.0
	copypasta@0.10.2
	core-foundation-sys@0.8.7
	core-foundation@0.9.4
	core-graphics-types@0.1.3
	core-graphics@0.23.2
	core-text@20.1.0
	crc32fast@1.5.0
	crossbeam-utils@0.8.21
	crossfont@0.8.1
	cstr@0.2.12
	cursor-icon@1.2.0
	dirs-sys@0.5.0
	dirs@6.0.0
	dispatch2@0.3.0
	dispatch@0.2.0
	dlib@0.5.2
	downcast-rs@1.2.1
	dpi@0.1.2
	dwrote@0.11.5
	embed-resource@3.0.6
	equivalent@1.0.2
	errno@0.3.14
	error-code@3.3.2
	fastrand@2.3.0
	fdeflate@0.3.7
	find-msvc-tools@0.1.3
	flate2@1.1.4
	foreign-types-macros@0.2.3
	foreign-types-shared@0.3.1
	foreign-types@0.5.0
	freetype-rs@0.36.0
	freetype-sys@0.20.1
	fsevent-sys@4.1.0
	futures-io@0.3.31
	gethostname@1.0.2
	getrandom@0.2.16
	getrandom@0.3.3
	gl_generator@0.14.0
	glutin@0.32.3
	glutin_egl_sys@0.7.1
	glutin_glx_sys@0.6.1
	glutin_wgl_sys@0.6.1
	hashbrown@0.16.0
	heck@0.5.0
	hermit-abi@0.5.2
	home@0.5.11
	indexmap@2.11.4
	inotify-sys@0.1.5
	inotify@0.11.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.15
	jni-sys@0.3.0
	jni@0.21.1
	jobserver@0.1.34
	js-sys@0.3.81
	khronos_api@3.1.0
	kqueue-sys@1.0.4
	kqueue@1.1.1
	lazy_static@1.5.0
	libc@0.2.176
	libloading@0.8.9
	libredox@0.1.10
	linux-raw-sys@0.11.0
	linux-raw-sys@0.4.15
	lock_api@0.4.14
	log@0.4.28
	memchr@2.7.6
	memmap2@0.9.8
	miniz_oxide@0.8.9
	mio@1.0.4
	miow@0.6.1
	ndk-context@0.1.1
	ndk-sys@0.6.0+11769913
	ndk@0.9.0
	notify-types@2.0.0
	notify@8.2.0
	num_enum@0.7.4
	num_enum_derive@0.7.4
	objc-sys@0.3.5
	objc2-app-kit@0.2.2
	objc2-app-kit@0.3.2
	objc2-cloud-kit@0.2.2
	objc2-contacts@0.2.2
	objc2-core-data@0.2.2
	objc2-core-foundation@0.3.2
	objc2-core-image@0.2.2
	objc2-core-location@0.2.2
	objc2-encode@4.1.0
	objc2-foundation@0.2.2
	objc2-foundation@0.3.2
	objc2-link-presentation@0.2.2
	objc2-metal@0.2.2
	objc2-quartz-core@0.2.2
	objc2-symbols@0.2.2
	objc2-ui-kit@0.2.2
	objc2-uniform-type-identifiers@0.2.2
	objc2-user-notifications@0.2.2
	objc2@0.5.2
	objc2@0.6.3
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	option-ext@0.2.0
	orbclient@0.3.48
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	percent-encoding@2.3.2
	pin-project-internal@1.1.10
	pin-project-lite@0.2.16
	pin-project@1.1.10
	piper@0.2.4
	pkg-config@0.3.32
	png@0.17.16
	polling@3.11.0
	proc-macro-crate@3.4.0
	proc-macro2@1.0.101
	quick-xml@0.37.5
	quote@1.0.41
	r-efi@5.3.0
	raw-window-handle@0.6.2
	redox_syscall@0.4.1
	redox_syscall@0.5.18
	redox_users@0.5.2
	regex-automata@0.4.11
	regex-syntax@0.8.6
	rustc_version@0.4.1
	rustix-openpty@0.2.0
	rustix@0.38.44
	rustix@1.1.2
	rustversion@1.0.22
	ryu@1.0.20
	same-file@1.0.6
	scoped-tls@1.0.1
	scopeguard@1.2.0
	sctk-adwaita@0.10.1
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	serde_spanned@1.0.2
	serde_yaml@0.9.34+deprecated
	shlex@1.3.0
	signal-hook-registry@1.4.6
	signal-hook@0.3.18
	simd-adler32@0.3.7
	slab@0.4.11
	smallvec@1.15.1
	smithay-client-toolkit@0.19.2
	smithay-clipboard@0.7.2
	smol_str@0.2.2
	strict-num@0.1.1
	strsim@0.11.1
	syn@2.0.106
	tempfile@3.23.0
	thiserror-impl@1.0.69
	thiserror-impl@2.0.17
	thiserror@1.0.69
	thiserror@2.0.17
	tiny-skia-path@0.11.4
	tiny-skia@0.11.4
	toml@0.9.7
	toml_datetime@0.7.2
	toml_edit@0.23.6
	toml_parser@1.0.3
	toml_writer@1.0.3
	tracing-core@0.1.34
	tracing@0.1.41
	unicode-ident@1.0.19
	unicode-segmentation@1.12.0
	unicode-width@0.2.2
	unsafe-libyaml@0.2.11
	utf8parse@0.2.2
	version_check@0.9.5
	vswhom-sys@0.1.3
	vswhom@0.1.0
	vte@0.15.0
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasi@0.14.7+wasi-0.2.4
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-backend@0.2.104
	wasm-bindgen-futures@0.4.54
	wasm-bindgen-macro-support@0.2.104
	wasm-bindgen-macro@0.2.104
	wasm-bindgen-shared@0.2.104
	wasm-bindgen@0.2.104
	wayland-backend@0.3.11
	wayland-client@0.31.11
	wayland-csd-frame@0.3.0
	wayland-cursor@0.31.11
	wayland-protocols-plasma@0.3.9
	wayland-protocols-wlr@0.3.9
	wayland-protocols@0.32.9
	wayland-scanner@0.31.7
	wayland-sys@0.31.7
	web-sys@0.3.81
	web-time@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.45.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.42.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	winit@0.30.12
	winnow@0.7.13
	winreg@0.55.0
	wio@0.2.2
	wit-bindgen@0.46.0
	x11-clipboard@0.9.3
	x11-dl@2.21.0
	x11rb-protocol@0.13.2
	x11rb@0.13.2
	xcursor@0.3.10
	xdg@3.0.0
	xkbcommon-dl@0.4.2
	xkeysym@0.2.1
	xml-rs@0.8.27
	yeslogic-fontconfig-sys@5.0.0
	zerocopy-derive@0.8.27
	zerocopy@0.8.27
"

MY_PV="${PV//_rc/-rc}"

RUST_MIN_VER="1.85.0"

inherit cargo desktop shell-completion

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
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
fi

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0
"
SLOT="0"
IUSE="wayland +X"

REQUIRED_USE="|| ( wayland X )"

COMMON_DEPEND="
	media-libs/fontconfig:=
	media-libs/freetype:2
	x11-libs/libxkbcommon[X?,wayland?]
	X? ( x11-libs/libxcb:= )
"

DEPEND="
	${COMMON_DEPEND}
"

RDEPEND="
	${COMMON_DEPEND}
	media-libs/mesa[X?,wayland?]
	virtual/zlib:=
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

	dofishcomp extra/completions/alacritty.fish

	dozshcomp extra/completions/_alacritty

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
		einfo "For information on how to configure alacritty, see the manpage:"
		einfo "man 5 alacritty"
	fi
}

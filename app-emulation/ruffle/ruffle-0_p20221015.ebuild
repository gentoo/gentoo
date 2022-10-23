# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	Inflector-0.11.4
	adler-1.0.2
	adler32-1.2.0
	ahash-0.7.6
	aho-corasick-0.7.19
	aliasable-0.1.3
	alsa-0.6.0
	alsa-sys-0.3.1
	android_system_properties-0.1.5
	anyhow-1.0.65
	approx-0.5.1
	arrayref-0.3.6
	arrayvec-0.5.2
	arrayvec-0.7.2
	ash-0.37.0+1.3.209
	async-channel-1.7.1
	atk-sys-0.15.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bindgen-0.59.2
	bit-set-0.5.3
	bit-vec-0.6.3
	bit_field-0.10.1
	bitflags-1.3.2
	bitflags_serde_shim-0.2.2
	bitstream-io-1.5.0
	bitvec-0.19.6
	block-0.1.6
	block-buffer-0.10.3
	bstr-0.2.17
	build_const-0.2.2
	bumpalo-3.11.0
	bytemuck-1.12.1
	bytemuck_derive-1.2.1
	byteorder-1.4.3
	bytes-1.2.1
	cache-padded-1.2.0
	cairo-sys-rs-0.15.1
	calloop-0.10.1
	castaway-0.1.2
	cc-1.0.73
	cesu8-1.1.0
	cexpr-0.6.0
	cfg-expr-0.10.3
	cfg-if-0.1.10
	cfg-if-1.0.0
	cfg_aliases-0.1.1
	chrono-0.4.22
	clang-sys-1.4.0
	clap-4.0.15
	clap_derive-4.0.13
	clap_lex-0.3.0
	clipboard-0.5.0
	clipboard-win-2.2.0
	cmake-0.1.48
	cocoa-0.24.0
	cocoa-foundation-0.1.0
	codespan-reporting-0.11.1
	color_quant-1.1.0
	colored-2.0.0
	combine-4.6.6
	concurrent-queue-1.2.4
	console-0.15.2
	console_error_panic_hook-0.1.7
	console_log-0.2.0
	convert_case-0.6.0
	cookie-factory-0.3.2
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	core-graphics-0.22.3
	core-graphics-types-0.1.1
	core-text-19.2.0
	coreaudio-rs-0.10.0
	coreaudio-sys-0.2.10
	cpal-0.14.0
	cpufeatures-0.2.5
	crc-1.8.1
	crc32fast-1.3.2
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.11
	crossbeam-utils-0.8.12
	crossfont-0.5.0
	crunchy-0.2.2
	crypto-common-0.1.6
	csv-1.1.6
	csv-core-0.1.10
	ctor-0.1.23
	cty-0.2.2
	curl-0.4.44
	curl-sys-0.4.56+curl-7.83.1
	cxx-1.0.78
	cxx-build-1.0.78
	cxxbridge-flags-1.0.78
	cxxbridge-macro-1.0.78
	d3d12-0.5.0
	darling-0.13.4
	darling-0.14.1
	darling_core-0.13.4
	darling_core-0.14.1
	darling_macro-0.13.4
	darling_macro-0.14.1
	derive-try-from-primitive-1.0.0
	diff-0.1.13
	digest-0.10.5
	dirs-4.0.0
	dirs-sys-0.3.7
	dispatch-0.2.0
	dlib-0.5.0
	downcast-rs-1.2.0
	dwrote-0.11.0
	either-1.8.0
	embed-resource-1.7.2
	encode_unicode-0.3.6
	encoding_rs-0.8.31
	enum-map-2.4.1
	enum-map-derive-0.10.0
	enumset-1.0.12
	enumset_derive-0.6.1
	env_logger-0.9.1
	euclid-0.22.7
	event-listener-2.5.3
	expat-sys-2.1.6
	exr-1.5.2
	fastrand-1.8.0
	flate2-1.0.24
	float_next_after-0.1.5
	flume-0.10.14
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-0.5.0
	foreign-types-macros-0.2.2
	foreign-types-shared-0.1.1
	foreign-types-shared-0.3.1
	form_urlencoded-1.1.0
	freetype-rs-0.26.0
	freetype-sys-0.13.1
	funty-1.1.0
	futures-0.3.24
	futures-channel-0.3.24
	futures-core-0.3.24
	futures-executor-0.3.24
	futures-io-0.3.24
	futures-lite-1.12.0
	futures-macro-0.3.24
	futures-sink-0.3.24
	futures-task-0.3.24
	futures-util-0.3.24
	fxhash-0.2.1
	gdk-pixbuf-sys-0.15.10
	gdk-sys-0.15.1
	generational-arena-0.2.8
	generic-array-0.14.6
	getrandom-0.2.7
	gif-0.11.4
	gio-sys-0.15.10
	glib-sys-0.15.10
	glob-0.3.0
	glow-0.11.2
	gobject-sys-0.15.10
	gpu-alloc-0.5.3
	gpu-alloc-types-0.2.0
	gpu-descriptor-0.2.3
	gpu-descriptor-types-0.1.1
	gtk-sys-0.15.3
	half-2.1.0
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	hexf-parse-0.2.1
	http-0.2.8
	humantime-2.1.0
	iana-time-zone-0.1.51
	iana-time-zone-haiku-0.1.0
	ident_case-1.0.1
	idna-0.3.0
	image-0.24.4
	indexmap-1.9.1
	indicatif-0.17.1
	instant-0.1.12
	isahc-1.7.2
	itoa-0.4.8
	itoa-1.0.4
	jni-0.19.0
	jni-sys-0.3.0
	jobserver-0.1.25
	jpeg-decoder-0.2.6
	js-sys-0.3.60
	khronos-egl-4.1.0
	lazy_static-1.4.0
	lazycell-1.3.0
	lebe-0.5.2
	lexical-core-0.7.6
	libc-0.2.135
	libflate-1.2.0
	libflate_lz77-1.1.0
	libloading-0.7.3
	libnghttp2-sys-0.1.7+1.45.0
	libz-sys-1.1.8
	link-cplusplus-1.0.7
	lock_api-0.4.9
	log-0.4.17
	lyon-1.0.0
	lyon_algorithms-1.0.1
	lyon_geom-1.0.1
	lyon_path-1.0.1
	lyon_tessellation-1.0.4
	lzma-rs-0.2.0
	mach-0.3.2
	malloc_buf-0.0.6
	memchr-2.5.0
	memmap2-0.5.7
	memoffset-0.6.5
	metal-0.24.0
	mime-0.3.16
	minimal-lexical-0.2.1
	minimp3-0.5.1
	minimp3-sys-0.3.2
	miniz_oxide-0.5.4
	miniz_oxide-0.6.2
	mio-0.8.4
	naga-0.10.0
	nanorand-0.7.0
	ndk-0.6.0
	ndk-0.7.0
	ndk-context-0.1.1
	ndk-glue-0.7.0
	ndk-macro-0.3.0
	ndk-sys-0.3.0
	ndk-sys-0.4.0
	nix-0.23.1
	nix-0.24.2
	nom-6.1.2
	nom-7.1.1
	num-bigint-0.4.3
	num-complex-0.4.2
	num-derive-0.3.3
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.13.1
	num_enum-0.5.7
	num_enum_derive-0.5.7
	num_threads-0.1.6
	number_prefix-0.4.0
	objc-0.2.7
	objc-foundation-0.1.1
	objc_exception-0.1.2
	objc_id-0.1.1
	oboe-0.4.6
	oboe-sys-0.4.5
	once_cell-1.15.0
	openssl-probe-0.1.5
	openssl-sys-0.9.76
	os_str_bytes-6.3.0
	ouroboros-0.15.5
	ouroboros_macro-0.15.5
	output_vt100-0.1.3
	pango-sys-0.15.10
	parking-2.0.0
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	path-slash-0.2.1
	peeking_take_while-0.1.2
	percent-encoding-2.2.0
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	png-0.17.6
	polling-2.3.0
	ppv-lite86-0.2.16
	pretty_assertions-1.3.0
	primal-check-0.3.3
	proc-macro-crate-1.2.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.46
	profiling-1.0.7
	quote-1.0.21
	radium-0.5.3
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	range-alloc-0.1.2
	raw-window-handle-0.4.3
	raw-window-handle-0.5.0
	rayon-1.5.3
	rayon-core-1.9.3
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.6.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	regress-0.4.1
	renderdoc-sys-0.7.1
	rfd-0.10.0
	rle-decode-fast-1.0.3
	ron-0.8.0
	rustc-hash-1.1.0
	rustc_version-0.4.0
	rustdct-0.7.0
	rustfft-6.0.1
	rustversion-1.0.9
	ryu-1.0.11
	safe_arch-0.5.2
	safe_arch-0.6.0
	same-file-1.0.6
	schannel-0.1.20
	scoped-tls-1.0.0
	scoped_threadpool-0.1.9
	scopeguard-1.1.0
	scratch-1.0.2
	sctk-adwaita-0.4.2
	semver-1.0.14
	serde-1.0.145
	serde-wasm-bindgen-0.4.5
	serde-xml-rs-0.6.0
	serde_derive-1.0.145
	serde_json-1.0.86
	servo-fontconfig-0.5.1
	servo-fontconfig-sys-5.1.0
	sha2-0.10.6
	shlex-1.1.0
	simple_asn1-0.6.2
	slab-0.4.7
	slice-deque-0.3.0
	slotmap-1.0.6
	sluice-0.5.5
	smallvec-1.10.0
	smithay-client-toolkit-0.16.0
	socket2-0.4.7
	spin-0.9.4
	spirv-0.2.0+1.5.4
	static_assertions-1.1.0
	stdweb-0.1.3
	strength_reduce-0.2.3
	strsim-0.10.0
	symphonia-0.5.1
	symphonia-bundle-mp3-0.5.1
	symphonia-core-0.5.1
	symphonia-metadata-0.5.1
	syn-1.0.102
	synstructure-0.12.6
	system-deps-6.0.2
	tap-1.0.1
	termcolor-1.1.3
	terminal_size-0.1.17
	thiserror-1.0.37
	thiserror-impl-1.0.37
	threadpool-1.8.1
	tiff-0.7.3
	time-0.1.44
	time-0.3.15
	time-macros-0.2.4
	tiny-skia-0.7.0
	tiny-skia-path-0.7.0
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	toml-0.5.9
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-futures-0.2.5
	transpose-0.2.1
	typed-arena-2.0.1
	typenum-1.15.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.5
	unicode-normalization-0.1.22
	unicode-segmentation-1.10.0
	unicode-width-0.1.10
	unicode-xid-0.2.4
	url-2.3.1
	vcpkg-0.2.15
	vec_map-0.8.2
	version-compare-0.1.0
	version_check-0.9.4
	vswhom-0.1.0
	vswhom-sys-0.1.1
	waker-fn-1.1.0
	walkdir-2.3.2
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-futures-0.4.33
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	wayland-client-0.29.5
	wayland-commons-0.29.5
	wayland-cursor-0.29.5
	wayland-protocols-0.29.5
	wayland-scanner-0.29.5
	wayland-sys-0.29.5
	weak-table-0.3.2
	web-sys-0.3.60
	webbrowser-0.8.0
	weezl-0.1.7
	wepoll-ffi-0.1.2
	wgpu-0.14.0
	wgpu-core-0.14.0
	wgpu-hal-0.14.0
	wgpu-types-0.14.0
	wide-0.7.5
	widestring-1.0.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.37.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_aarch64_msvc-0.37.0
	windows_i686_gnu-0.36.1
	windows_i686_gnu-0.37.0
	windows_i686_msvc-0.36.1
	windows_i686_msvc-0.37.0
	windows_x86_64_gnu-0.36.1
	windows_x86_64_gnu-0.37.0
	windows_x86_64_msvc-0.36.1
	windows_x86_64_msvc-0.37.0
	winit-0.27.4
	winreg-0.10.1
	wio-0.2.2
	wyz-0.2.0
	x11-clipboard-0.3.3
	x11-dl-2.20.0
	xcb-0.8.2
	xcursor-0.3.4
	xml-rs-0.8.4
	yansi-0.5.1"
# python is needed by xcb-0.8.2 until update to >=0.10
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml(+)"
inherit cargo desktop flag-o-matic python-any-r1 xdg

# 0(github) 1(repo) 2(commit hash) 3(crate:workspace,...) [see core/Cargo.toml]
RUFFLE_GIT=(
	"RustAudio dasp f05a703d247bb504d7e812b51e95f3765d9c5e94 dasp"
	"ruffle-rs gc-arena 081b6883a522b38030b13744c80c84efbfcbae1f gc-arena:src/gc-arena"
	"ruffle-rs h263-rs 023e14c73e565c4c778d41f66cfbac5ece6419b2 h263-rs:h263,h263-rs-yuv:yuv"
	"ruffle-rs nellymoser 4a33521c29a918950df8ae9fe07e527ac65553f5 nellymoser-rs:."
	"ruffle-rs nihav-vp6 9416fcc9fc8aab8f4681aa9093b42922214abbd3 nihav_codec_support:nihav-codec-support,nihav_core:nihav-core,nihav_duck:nihav-duck"
	"ruffle-rs quick-xml 8496365ec1412eb5ba5de350937b6bce352fa0ba quick-xml:."
	"ruffle-rs rust-flash-lso 19fecd07b9888c4bdaa66771c468095783b52bed flash-lso"
)
ruffle_uris() {
	cargo_crate_uris

	local g
	for g in "${RUFFLE_GIT[@]}"; do
		g=(${g})
		echo "https://github.com/${g[0]}/${g[1]}/archive/${g[2]}.tar.gz -> ${g[1]}-${g[2]}.tar.gz"
	done
}

# using _pYYYYMMDD over YYYY.MM.DD given ruffle has an underlaying version
# (0.1.0) which could get a non-nightly release eventually (YYYY. > 0.1.0)
MY_PV="nightly-${PV:3:4}-${PV:7:2}-${PV:9:2}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Flash Player emulator written in Rust"
HOMEPAGE="https://ruffle.rs/"
SRC_URI="
	https://github.com/ruffle-rs/ruffle/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	$(ruffle_uris)"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB curl"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib:=
	x11-libs/gtk+:3
	x11-libs/libxcb:="
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/jre:*
	virtual/pkgconfig
	>=virtual/rust-1.64"

QA_FLAGS_IGNORED="
	usr/bin/${PN}
	usr/bin/${PN}_exporter
	usr/bin/${PN}_scanner"

src_prepare() {
	default

	# use [patch] directive to register git snapshots of needed crates
	local crate g
	for g in "${RUFFLE_GIT[@]}"; do
		g=(${g})
		echo "[patch.\"https://github.com/${g[0]}/${g[1]}\"]"
		for crate in ${g[3]//,/ }; do
			echo "${crate%:*} = { path = \"../${g[1]}-${g[2]}/${crate#*:}\" }"
		done
	done >> Cargo.toml || die
}

src_compile() {
	filter-lto # does not play well with C code in crates

	cargo_src_compile --bins # note: configure --bins would skip tests
}

src_install() {
	dodoc README.md

	newicon web/packages/extension/assets/images/icon180.png ${PN}.png
	make_desktop_entry ${PN} ${PN^} ${PN} "AudioVideo;Player;Emulator;" \
		"MimeType=application/x-shockwave-flash;application/vnd.adobe.flash.movie;"

	cd target/$(usex debug{,} release) || die

	newbin ${PN}_desktop ${PN}
	newbin exporter ${PN}_exporter
	dobin ${PN}_scanner
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "${PN} is experimental software that is still under heavy development"
		elog "and only receiving nightly releases. Plans in Gentoo is to update"
		elog "roughly every months if no known major regressions (feel free to"
		elog "report if you feel a newer nightly is needed ahead of time)."
		elog
		elog "There is currently no plans to support wasm builds / browser"
		elog "extensions, this provides the desktop viewer and other tools."
	fi
}

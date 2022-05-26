# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	adler32-1.2.0
	ahash-0.7.6
	aho-corasick-0.7.18
	alsa-0.6.0
	alsa-sys-0.3.1
	ansi_term-0.12.1
	approx-0.5.1
	arrayvec-0.5.2
	arrayvec-0.7.2
	ash-0.34.0+1.2.203
	async-channel-1.6.1
	atk-sys-0.15.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bindgen-0.56.0
	bit-set-0.5.2
	bit-vec-0.6.3
	bit_field-0.10.1
	bitflags-1.3.2
	bitflags_serde_shim-0.2.2
	bitstream-io-1.3.0
	bitvec-0.19.6
	block-0.1.6
	block-buffer-0.10.2
	bstr-0.2.17
	build_const-0.2.2
	bumpalo-3.9.1
	bytemuck-1.9.1
	bytemuck_derive-1.1.0
	byteorder-1.4.3
	bytes-1.1.0
	cache-padded-1.2.0
	cairo-sys-rs-0.15.1
	calloop-0.9.3
	castaway-0.1.2
	cc-1.0.73
	cesu8-1.1.0
	cexpr-0.4.0
	cfg-expr-0.10.2
	cfg-if-0.1.10
	cfg-if-1.0.0
	cfg_aliases-0.1.1
	chrono-0.4.19
	clang-sys-1.3.1
	clap-3.1.17
	clap_derive-3.1.7
	clap_lex-0.2.0
	clipboard-0.5.0
	clipboard-win-2.2.0
	cocoa-0.24.0
	cocoa-foundation-0.1.0
	codespan-reporting-0.11.1
	color_quant-1.1.0
	combine-4.6.3
	concurrent-queue-1.2.2
	console-0.15.0
	console_error_panic_hook-0.1.7
	console_log-0.2.0
	cookie-factory-0.3.2
	copyless-0.1.5
	core-foundation-0.7.0
	core-foundation-0.9.3
	core-foundation-sys-0.7.0
	core-foundation-sys-0.8.3
	core-graphics-0.19.2
	core-graphics-0.22.3
	core-graphics-types-0.1.1
	core-video-sys-0.1.4
	coreaudio-rs-0.10.0
	coreaudio-sys-0.2.9
	cpal-0.13.5
	cpufeatures-0.2.1
	crc-1.8.1
	crc32fast-1.3.2
	crossbeam-channel-0.5.4
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.8
	crossbeam-utils-0.8.8
	crypto-common-0.1.3
	csv-1.1.6
	csv-core-0.1.10
	ctor-0.1.21
	cty-0.2.2
	curl-0.4.43
	curl-sys-0.4.54+curl-7.83.0
	d3d12-0.4.1
	darling-0.13.1
	darling_core-0.13.1
	darling_macro-0.13.1
	deflate-1.0.0
	derive-try-from-primitive-1.0.0
	diff-0.1.12
	digest-0.10.3
	dirs-4.0.0
	dirs-sys-0.3.6
	dispatch-0.2.0
	dlib-0.5.0
	downcast-rs-1.2.0
	either-1.6.1
	embed-resource-1.7.2
	encode_unicode-0.3.6
	encoding_rs-0.8.31
	enum-map-2.1.0
	enum-map-derive-0.8.0
	enumset-1.0.8
	enumset_derive-0.5.5
	env_logger-0.9.0
	euclid-0.22.6
	event-listener-2.5.2
	exr-1.4.2
	fastrand-1.7.0
	flate2-1.0.23
	float_next_after-0.1.5
	flume-0.10.12
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	funty-1.1.0
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-lite-1.12.0
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	fxhash-0.2.1
	gdk-pixbuf-sys-0.15.1
	gdk-sys-0.15.1
	generational-arena-0.2.8
	generic-array-0.14.5
	getrandom-0.2.6
	gif-0.11.3
	gio-sys-0.15.7
	glib-sys-0.15.7
	glob-0.3.0
	glow-0.11.2
	gobject-sys-0.15.9
	gpu-alloc-0.5.3
	gpu-alloc-types-0.2.0
	gpu-descriptor-0.2.2
	gpu-descriptor-types-0.1.1
	gtk-sys-0.15.3
	half-1.8.2
	hashbrown-0.11.2
	hashbrown-0.9.1
	heck-0.4.0
	hermit-abi-0.1.19
	hexf-parse-0.2.1
	http-0.2.6
	humantime-2.1.0
	ident_case-1.0.1
	idna-0.2.3
	image-0.24.2
	indexmap-1.6.2
	indicatif-0.16.2
	inflate-0.4.5
	inplace_it-0.3.3
	instant-0.1.12
	isahc-1.7.1
	itoa-0.4.8
	itoa-1.0.1
	jni-0.19.0
	jni-sys-0.3.0
	jobserver-0.1.24
	jpeg-decoder-0.1.22
	jpeg-decoder-0.2.6
	js-sys-0.3.57
	khronos-egl-4.1.0
	lazy_static-1.4.0
	lazycell-1.3.0
	lebe-0.5.1
	lexical-core-0.7.6
	libc-0.2.120
	libflate-1.2.0
	libflate_lz77-1.1.0
	libloading-0.7.3
	libnghttp2-sys-0.1.7+1.45.0
	libz-sys-1.1.5
	lock_api-0.4.6
	log-0.4.17
	lyon-0.17.10
	lyon_algorithms-0.17.7
	lyon_geom-0.17.6
	lyon_path-0.17.7
	lyon_tessellation-0.17.10
	lzma-rs-0.2.0
	mach-0.3.2
	malloc_buf-0.0.6
	matches-0.1.9
	memchr-2.4.1
	memmap2-0.3.1
	memoffset-0.6.5
	metal-0.23.1
	mime-0.3.16
	minimal-lexical-0.2.1
	minimp3-0.5.1
	minimp3-sys-0.3.2
	miniz_oxide-0.5.1
	mio-0.8.1
	miow-0.3.7
	naga-0.8.5
	nanorand-0.7.0
	ndk-0.5.0
	ndk-0.6.0
	ndk-context-0.1.0
	ndk-glue-0.5.1
	ndk-glue-0.6.1
	ndk-macro-0.3.0
	ndk-sys-0.2.2
	ndk-sys-0.3.0
	nix-0.22.3
	nix-0.23.1
	nom-5.1.2
	nom-6.1.2
	nom-7.1.1
	ntapi-0.3.7
	num-complex-0.4.0
	num-derive-0.3.3
	num-integer-0.1.44
	num-iter-0.1.42
	num-rational-0.4.0
	num-traits-0.2.15
	num_cpus-1.13.1
	num_enum-0.5.7
	num_enum_derive-0.5.7
	number_prefix-0.4.0
	objc-0.2.7
	objc-foundation-0.1.1
	objc_exception-0.1.2
	objc_id-0.1.1
	oboe-0.4.5
	oboe-sys-0.4.5
	once_cell-1.10.0
	openssl-probe-0.1.5
	openssl-sys-0.9.72
	os_str_bytes-6.0.0
	output_vt100-0.1.3
	pango-sys-0.15.1
	parking-2.0.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	path-slash-0.1.4
	peeking_take_while-0.1.2
	percent-encoding-2.1.0
	pin-project-1.0.10
	pin-project-internal-1.0.10
	pin-project-lite-0.2.8
	pin-utils-0.1.0
	pkg-config-0.3.24
	png-0.17.5
	polling-2.2.0
	ppv-lite86-0.2.16
	pretty_assertions-1.2.1
	primal-check-0.3.1
	proc-macro-crate-1.1.3
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.36
	profiling-1.0.5
	quote-1.0.18
	radium-0.5.3
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	range-alloc-0.1.2
	raw-window-handle-0.4.2
	rayon-1.5.2
	rayon-core-1.9.2
	redox_syscall-0.2.11
	redox_users-0.4.0
	regex-1.5.5
	regex-automata-0.1.10
	regex-syntax-0.6.25
	regress-0.4.1
	renderdoc-sys-0.7.1
	rfd-0.8.2
	rle-decode-fast-1.0.3
	ron-0.7.0
	rustc-hash-1.1.0
	rustc_version-0.4.0
	rustdct-0.7.0
	rustfft-6.0.1
	ryu-1.0.9
	safe_arch-0.6.0
	same-file-1.0.6
	schannel-0.1.19
	scoped-tls-1.0.0
	scoped_threadpool-0.1.9
	scopeguard-1.1.0
	semver-1.0.6
	serde-1.0.137
	serde_derive-1.0.137
	serde_json-1.0.81
	sha2-0.10.2
	shlex-0.1.1
	sid-0.6.1
	slab-0.4.5
	slice-deque-0.3.0
	slotmap-1.0.6
	sluice-0.5.5
	smallvec-1.8.0
	smithay-client-toolkit-0.15.3
	socket2-0.4.4
	spin-0.9.2
	spirv-0.2.0+1.5.4
	static_assertions-1.1.0
	stdweb-0.1.3
	strength_reduce-0.2.3
	strsim-0.10.0
	svg-0.10.0
	symphonia-0.5.0
	symphonia-bundle-mp3-0.5.0
	symphonia-core-0.5.0
	symphonia-metadata-0.5.0
	syn-1.0.92
	synstructure-0.12.6
	system-deps-6.0.2
	tap-1.0.1
	termcolor-1.1.3
	terminal_size-0.1.17
	textwrap-0.15.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	threadpool-1.8.1
	tiff-0.7.1
	time-0.1.43
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	toml-0.5.8
	tracing-0.1.32
	tracing-attributes-0.1.20
	tracing-core-0.1.23
	tracing-futures-0.2.5
	transpose-0.2.1
	typenum-1.15.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-width-0.1.9
	unicode-xid-0.2.2
	url-2.2.2
	vcpkg-0.2.15
	version-compare-0.1.0
	version_check-0.9.4
	vswhom-0.1.0
	vswhom-sys-0.1.1
	waker-fn-1.1.0
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.80
	wasm-bindgen-backend-0.2.80
	wasm-bindgen-futures-0.4.30
	wasm-bindgen-macro-0.2.80
	wasm-bindgen-macro-support-0.2.80
	wasm-bindgen-shared-0.2.80
	wayland-client-0.29.4
	wayland-commons-0.29.4
	wayland-cursor-0.29.4
	wayland-protocols-0.29.4
	wayland-scanner-0.29.4
	wayland-sys-0.29.4
	weak-table-0.3.2
	web-sys-0.3.57
	webbrowser-0.7.1
	weezl-0.1.5
	wepoll-ffi-0.1.2
	wgpu-0.12.0
	wgpu-core-0.12.2
	wgpu-hal-0.12.4
	wgpu-types-0.12.0
	wide-0.7.4
	widestring-0.5.1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.35.0
	windows_aarch64_msvc-0.35.0
	windows_i686_gnu-0.35.0
	windows_i686_msvc-0.35.0
	windows_x86_64_gnu-0.35.0
	windows_x86_64_msvc-0.35.0
	winit-0.26.1
	winreg-0.10.1
	wyz-0.2.0
	x11-clipboard-0.3.3
	x11-dl-2.19.1
	xcb-0.8.2
	xcursor-0.3.4
	xml-rs-0.8.4"
# python is needed by xcb-0.8.2 until update to >=0.10
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml(+)"
inherit cargo desktop flag-o-matic python-any-r1 xdg

# 0(github) 1(repo) 2(commit hash) 3(crate:workspace,...) [see core/Cargo.toml]
RUFFLE_GIT=(
	"RustAudio dasp f05a703d247bb504d7e812b51e95f3765d9c5e94 dasp"
	"ruffle-rs gc-arena 4931b3bc25b2b74174ff5eb9c34ae0dda732778b gc-arena:src/gc-arena"
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

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0 ZLIB curl"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	media-libs/alsa-lib
	sys-libs/zlib:=
	x11-libs/gtk+:3
	x11-libs/libxcb:="
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	>=virtual/rust-1.56"

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
	filter-flags '-flto*' # undefined references with ring crate and more

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
		elog "roughly every two weeks if no known major regressions."
		elog
		elog "There is currently no plans to support wasm builds / browser"
		elog "extensions, this provides the desktop viewer and other tools."
	fi
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	aes@0.8.3
	ahash@0.8.6
	aho-corasick@1.1.2
	allocator-api2@0.2.16
	ammonia@3.3.0
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anes@0.1.6
	anstream@0.6.4
	anstyle-parse@0.2.3
	anstyle-query@1.0.1
	anstyle-wincon@3.0.2
	anstyle@1.0.4
	anyhow@1.0.75
	apple-bundles@0.17.0
	arrayref@0.3.7
	arrayvec@0.7.4
	ash@0.37.3+1.3.251
	assert-json-diff@2.0.2
	async-channel@1.9.0
	async-compression@0.4.5
	async-stream-impl@0.3.5
	async-stream@0.3.5
	async-trait@0.1.74
	autocfg@1.1.0
	axum-client-ip@0.4.2
	axum-core@0.3.4
	axum-macros@0.3.8
	axum@0.6.20
	backtrace@0.3.69
	base64@0.13.1
	base64@0.21.5
	base64ct@1.6.0
	bincode@2.0.0-rc.3
	bit-set@0.5.3
	bit-vec@0.6.3
	bit_field@0.10.2
	bitflags@1.3.2
	bitflags@2.4.1
	blake3@1.5.0
	block-buffer@0.10.4
	block-padding@0.3.3
	block@0.1.6
	bstr@1.8.0
	bumpalo@3.14.0
	burn-autodiff@0.11.1
	burn-candle@0.11.1
	burn-common@0.11.1
	burn-compute@0.11.1
	burn-core@0.11.1
	burn-dataset@0.11.1
	burn-derive@0.11.1
	burn-fusion@0.11.1
	burn-ndarray@0.11.1
	burn-tch@0.11.1
	burn-tensor-testgen@0.11.1
	burn-tensor@0.11.1
	burn-train@0.11.1
	burn-wgpu@0.11.1
	burn@0.11.1
	bytemuck@1.14.0
	bytemuck_derive@1.5.0
	byteorder@1.5.0
	bytes@1.5.0
	bzip2-sys@0.1.11+1.0.8
	bzip2@0.4.4
	camino@1.1.6
	candle-core@0.3.1
	cast@0.3.0
	cbc@0.1.2
	cc@1.0.83
	cfg-if@1.0.0
	chrono@0.4.31
	ciborium-io@0.2.1
	ciborium-ll@0.2.1
	ciborium@0.2.1
	cipher@0.4.4
	clap@4.4.11
	clap_builder@4.4.11
	clap_complete@4.4.4
	clap_derive@4.4.7
	clap_lex@0.6.0
	coarsetime@0.1.33
	codespan-reporting@0.11.1
	codespan@0.11.1
	color_quant@1.1.0
	colorchoice@1.0.0
	com-rs@0.2.1
	concurrent-queue@2.4.0
	constant_time_eq@0.1.5
	constant_time_eq@0.3.0
	convert_case@0.6.0
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	core-graphics-types@0.1.3
	cpufeatures@0.2.11
	crc32fast@1.3.2
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	crunchy@0.2.2
	crypto-common@0.1.6
	csv-core@0.1.11
	csv@1.3.0
	d3d12@0.7.0
	dashmap@5.5.3
	data-encoding@2.5.0
	deadpool-runtime@0.1.3
	deadpool@0.9.5
	deranged@0.3.10
	derive-new@0.5.9
	des@0.8.1
	difflib@0.4.0
	digest@0.10.7
	dirs-sys@0.4.1
	dirs@5.0.1
	displaydoc@0.2.4
	doc-comment@0.3.3
	duct@0.13.6
	dunce@1.0.4
	dyn-stack@0.10.0
	either@1.9.0
	elasticlunr-rs@3.0.2
	encoding_rs@0.8.33
	env_logger@0.10.1
	envy@0.4.2
	equivalent@1.0.1
	errno@0.3.8
	event-listener@2.5.3
	exr@1.6.4
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	faster-hex@0.8.1
	fastrand@1.9.0
	fastrand@2.0.1
	fdeflate@0.3.1
	filetime@0.2.23
	find-crate@0.6.3
	find-winsdk@0.2.0
	fixedbitset@0.4.2
	flate2@1.0.28
	fluent-bundle@0.15.2
	fluent-langneg@0.13.0
	fluent-syntax@0.11.0
	fluent@0.16.0
	flume@0.10.14
	flume@0.11.0
	fnv@1.0.7
	foreign-types-macros@0.2.3
	foreign-types-shared@0.1.1
	foreign-types-shared@0.3.1
	foreign-types@0.3.2
	foreign-types@0.5.0
	form_urlencoded@1.2.1
	forwarded-header-value@0.1.1
	fs2@0.4.3
	fsevent-sys@4.1.0
	futf@0.1.5
	futures-channel@0.3.29
	futures-core@0.3.29
	futures-executor@0.3.29
	futures-intrusive@0.5.0
	futures-io@0.3.29
	futures-lite@1.13.0
	futures-macro@0.3.29
	futures-sink@0.3.29
	futures-task@0.3.29
	futures-timer@3.0.2
	futures-util@0.3.29
	futures@0.3.29
	gemm-c32@0.16.15
	gemm-c64@0.16.15
	gemm-common@0.16.15
	gemm-f16@0.16.15
	gemm-f32@0.16.15
	gemm-f64@0.16.15
	gemm@0.16.15
	generic-array@0.14.7
	getopts@0.2.21
	getrandom@0.1.16
	getrandom@0.2.11
	gif@0.12.0
	gimli@0.28.1
	gix-features@0.33.0
	gix-fs@0.5.0
	gix-hash@0.12.0
	gix-tempfile@8.0.0
	gix-trace@0.1.3
	gl_generator@0.14.0
	glob@0.3.1
	globset@0.4.14
	glow@0.13.0
	glutin_wgl_sys@0.5.0
	gpu-alloc-types@0.3.0
	gpu-alloc@0.6.0
	gpu-allocator@0.23.0
	gpu-descriptor-types@0.1.2
	gpu-descriptor@0.2.4
	h2@0.3.22
	half@1.8.2
	half@2.3.1
	handlebars@4.5.0
	hashbrown@0.13.2
	hashbrown@0.14.3
	hashlink@0.8.4
	hassle-rs@0.10.0
	headers-core@0.2.0
	headers@0.3.9
	heck@0.4.1
	hermit-abi@0.3.3
	hex@0.4.3
	hexf-parse@0.2.1
	hmac@0.12.1
	home@0.5.5
	html5ever@0.26.0
	htmlescape@0.3.1
	http-body@0.4.5
	http-range-header@0.3.1
	http-types@2.12.0
	http@0.2.11
	httparse@1.8.0
	httpdate@1.0.3
	humantime@2.1.0
	hyper-rustls@0.24.2
	hyper-tls@0.5.0
	hyper@0.14.27
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.58
	id_tree@1.8.0
	idna@0.5.0
	ignore@0.4.21
	image@0.24.7
	indexmap@2.1.0
	indoc@2.0.4
	infer@0.2.3
	inflections@1.1.1
	inotify-sys@0.1.5
	inotify@0.9.6
	inout@0.1.3
	instant@0.1.12
	intl-memoizer@0.5.1
	intl_pluralrules@7.0.2
	ipnet@2.9.0
	is-terminal@0.4.9
	itertools@0.10.5
	itertools@0.11.0
	itertools@0.12.0
	itoa@1.0.9
	jobserver@0.1.27
	jpeg-decoder@0.3.0
	js-sys@0.3.66
	junction@1.0.0
	khronos-egl@6.0.0
	khronos_api@3.1.0
	kqueue-sys@1.0.4
	kqueue@1.0.8
	lazy_static@1.4.0
	lebe@0.5.2
	libc@0.2.150
	libloading@0.7.4
	libloading@0.8.1
	libm@0.2.8
	libredox@0.0.1
	libsqlite3-sys@0.27.0
	line-wrap@0.1.1
	linkify@0.7.0
	linux-raw-sys@0.4.12
	lock_api@0.4.11
	log@0.4.20
	lzma-sys@0.1.20
	mac@0.1.1
	malloc_buf@0.0.6
	maplit@1.0.2
	markup5ever@0.11.0
	markup5ever_rcdom@0.2.0
	matchers@0.1.0
	matches@0.1.10
	matchit@0.7.3
	matrixmultiply@0.3.8
	mdbook@0.4.36
	memchr@2.6.4
	memmap2@0.7.1
	memoffset@0.9.0
	metal@0.27.0
	mime@0.3.17
	mime_guess@2.0.4
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	mio@0.8.9
	multer@2.1.0
	multimap@0.8.3
	naga@0.14.1
	nanorand@0.7.0
	native-tls@0.2.11
	ndarray-rand@0.14.0
	ndarray@0.15.6
	new_debug_unreachable@1.0.4
	nom@7.1.3
	nonempty@0.7.0
	normpath@1.1.1
	notify-debouncer-mini@0.4.1
	notify@6.1.1
	nu-ansi-term@0.46.0
	num-complex@0.4.4
	num-format@0.4.4
	num-integer@0.1.45
	num-rational@0.4.1
	num-traits@0.2.17
	num_cpus@1.16.0
	num_enum@0.7.1
	num_enum_derive@0.7.1
	objc@0.2.7
	objc_exception@0.1.2
	object@0.32.1
	once_cell@1.18.0
	oorandom@11.1.3
	opener@0.6.1
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.97
	openssl@0.10.61
	option-ext@0.2.0
	os_pipe@1.1.4
	overload@0.1.1
	p12@0.6.3
	parking@2.2.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	password-hash@0.4.2
	paste@1.0.14
	pathdiff@0.2.1
	pbkdf2@0.11.0
	pem@1.1.1
	percent-encoding@2.3.1
	pest@2.7.5
	pest_derive@2.7.5
	pest_generator@2.7.5
	pest_meta@2.7.5
	petgraph@0.6.4
	phf@0.10.1
	phf@0.11.2
	phf_codegen@0.10.0
	phf_generator@0.10.0
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.10.0
	phf_shared@0.11.2
	pin-project-internal@1.1.3
	pin-project-lite@0.2.13
	pin-project@1.1.3
	pin-utils@0.1.0
	pkg-config@0.3.27
	plist@1.6.0
	plotters-backend@0.3.5
	plotters-svg@0.3.5
	plotters@0.3.5
	png@0.17.10
	pollster@0.3.0
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	presser@0.3.1
	prettyplease@0.2.15
	proc-macro-crate@2.0.0
	proc-macro2@1.0.70
	profiling@1.0.11
	prost-build@0.12.3
	prost-derive@0.12.3
	prost-reflect@0.12.0
	prost-types@0.12.3
	prost@0.12.3
	pulldown-cmark@0.8.0
	pulldown-cmark@0.9.3
	pulp@0.18.6
	pyo3-build-config@0.20.0
	pyo3-ffi@0.20.0
	pyo3-macros-backend@0.20.0
	pyo3-macros@0.20.0
	pyo3@0.20.0
	qoi@0.4.1
	quick-xml@0.31.0
	quote@1.0.33
	r2d2@0.8.10
	r2d2_sqlite@0.23.0
	rand@0.7.3
	rand@0.8.5
	rand_chacha@0.2.2
	rand_chacha@0.3.1
	rand_core@0.5.1
	rand_core@0.6.4
	rand_distr@0.4.3
	rand_hc@0.2.0
	range-alloc@0.1.3
	raw-cpuid@10.7.0
	raw-window-handle@0.5.2
	rawpointer@0.2.1
	rayon-core@1.12.0
	rayon@1.8.0
	rc2@0.8.1
	rcgen@0.10.0
	reborrow@0.5.5
	redox_syscall@0.4.1
	redox_users@0.4.4
	regex-automata@0.1.10
	regex-automata@0.4.3
	regex-syntax@0.6.29
	regex-syntax@0.8.2
	regex@1.10.2
	renderdoc-sys@1.0.0
	reqwest@0.11.22
	retain_mut@0.1.9
	ring@0.16.20
	ring@0.17.7
	rmp-serde@1.1.2
	rmp@0.8.12
	rusqlite@0.30.0
	rustc-demangle@0.1.23
	rustc-hash@1.1.0
	rustix@0.38.26
	rustls-native-certs@0.6.3
	rustls-pemfile@1.0.4
	rustls-webpki@0.101.7
	rustls@0.21.9
	rustversion@1.0.14
	ryu@1.0.15
	safemem@0.3.3
	safetensors@0.3.3
	same-file@1.0.6
	sanitize-filename@0.5.0
	schannel@0.1.22
	scheduled-thread-pool@0.2.7
	scoped-tls@1.0.1
	scopeguard@1.2.0
	sct@0.7.1
	security-framework-sys@2.9.1
	security-framework@2.9.2
	self_cell@0.10.3
	self_cell@1.0.2
	semver@1.0.20
	seq-macro@0.3.5
	serde-aux@4.3.1
	serde@1.0.193
	serde_derive@1.0.193
	serde_json@1.0.108
	serde_path_to_error@0.1.14
	serde_qs@0.8.5
	serde_repr@0.1.17
	serde_rusqlite@0.34.0
	serde_tuple@0.5.0
	serde_tuple_macros@0.5.0
	serde_urlencoded@0.7.1
	sha1@0.10.6
	sha2@0.10.8
	sharded-slab@0.1.7
	shared_child@1.0.0
	shlex@1.2.0
	signal-hook-registry@1.4.1
	signal-hook@0.3.17
	simd-adler32@0.3.7
	simple-file-manifest@0.11.0
	siphasher@0.3.11
	slab@0.4.9
	slotmap@1.0.7
	smallvec@1.11.2
	snafu-derive@0.7.5
	snafu@0.7.5
	snowflake@1.3.0
	socket2@0.4.10
	socket2@0.5.5
	spin@0.5.2
	spin@0.9.8
	spirv@0.2.0+1.5.4
	stable_deref_trait@1.2.0
	static_assertions@1.1.0
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	strsim@0.10.0
	strum@0.25.0
	strum_macros@0.25.3
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.39
	sync_wrapper@0.1.2
	synstructure@0.13.0
	system-configuration-sys@0.5.0
	system-configuration@0.5.1
	tar@0.4.40
	target-lexicon@0.12.12
	tch@0.14.0
	tempfile@3.8.1
	tendril@0.4.3
	termcolor@1.4.0
	terminal_size@0.3.0
	text_placeholder@0.5.0
	thiserror-impl@1.0.50
	thiserror@1.0.50
	thread-tree@0.3.3
	thread_local@1.1.7
	tiff@0.9.0
	time-core@0.1.2
	time-macros@0.2.15
	time@0.3.30
	tinystr@0.7.5
	tinytemplate@1.2.1
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-macros@2.2.0
	tokio-native-tls@0.3.1
	tokio-rustls@0.24.1
	tokio-socks@0.5.1
	tokio-stream@0.1.14
	tokio-tungstenite@0.20.1
	tokio-util@0.7.10
	tokio@1.34.0
	toml@0.5.11
	toml_datetime@0.6.5
	toml_edit@0.20.7
	topological-sort@0.2.2
	torch-sys@0.14.0
	tower-http@0.4.4
	tower-layer@0.3.2
	tower-service@0.3.2
	tower@0.4.13
	tracing-appender@0.2.3
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	tracing@0.1.40
	try-lock@0.2.4
	tugger-common@0.10.0
	tugger-windows-codesign@0.10.0
	tugger-windows@0.10.0
	tungstenite@0.20.1
	type-map@0.4.0
	typenum@1.17.0
	ucd-trie@0.1.6
	unic-char-property@0.9.0
	unic-char-range@0.9.0
	unic-common@0.9.0
	unic-langid-impl@0.9.3
	unic-langid-macros-impl@0.9.3
	unic-langid-macros@0.9.3
	unic-langid@0.9.3
	unic-ucd-category@0.9.0
	unic-ucd-version@0.9.0
	unicase@2.6.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unicode-width@0.1.11
	unicode-xid@0.2.4
	unindent@0.2.3
	untrusted@0.7.1
	untrusted@0.9.0
	ureq@2.9.1
	url@2.5.0
	utf-8@0.7.6
	utf8parse@0.2.1
	utime@0.3.1
	uuid@1.6.1
	valuable@0.1.0
	vcpkg@0.2.15
	version_check@0.9.4
	waker-fn@1.1.1
	walkdir@2.4.0
	want@0.3.1
	warp@0.3.6
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.9.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.89
	wasm-bindgen-futures@0.4.39
	wasm-bindgen-macro-support@0.2.89
	wasm-bindgen-macro@0.2.89
	wasm-bindgen-shared@0.2.89
	wasm-bindgen@0.2.89
	wasm-streams@0.3.0
	web-sys@0.3.64
	webpki-roots@0.25.3
	weezl@0.1.7
	wgpu-core@0.18.1
	wgpu-hal@0.18.1
	wgpu-types@0.18.0
	wgpu@0.18.0
	which@4.4.2
	which@5.0.0
	widestring@1.0.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.51.1
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.0
	windows@0.51.1
	windows@0.52.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.0
	winnow@0.5.25
	winreg@0.5.1
	winreg@0.50.0
	wiremock@0.5.22
	xattr@1.0.1
	xml-rs@0.8.19
	xml5ever@0.17.0
	xz2@0.1.7
	yasna@0.5.2
	yoke-derive@0.7.3
	yoke@0.7.3
	zerocopy-derive@0.7.31
	zerocopy@0.7.31
	zerofrom-derive@0.1.3
	zerofrom@0.1.3
	zip@0.6.6
	zstd-safe@5.0.2+zstd.1.5.2
	zstd-safe@7.0.0
	zstd-sys@2.0.9+zstd.1.5.5
	zstd@0.11.2+zstd.1.5.2
	zstd@0.13.0
	zune-inflate@0.2.54
"

declare -A GIT_CRATES=(
	[fsrs]='https://github.com/open-spaced-repetition/fsrs-rs;58ca25ed2bc4bb1dc376208bbcaed7f5a501b941;fsrs-rs-%commit%'
	[linkcheck]='https://github.com/ankitects/linkcheck;184b2ca50ed39ca43da13f0b830a463861adb9ca;linkcheck-%commit%'
	[percent-encoding-iri]='https://github.com/ankitects/rust-url;bb930b8d089f4d30d7d19c12e54e66191de47b88;rust-url-%commit%/percent_encoding'
)

# this is for versioning anki internally
ANKI_COMMIT="1a1d4d5419c6b57ef3baf99c9d2d9cf85d36ae0a"
I18N_COMMIT="fb301cc62da3b7a83b4ea266d9a2e70cfc1a8418"
QT_COMMIT="8c2191a7c797747cec767e3953bbbcc50acc5246"

PYTHON_COMPAT=( python3_1{0..2} )
PYTHON_REQ_USE="sqlite"

inherit cargo desktop optfeature python-single-r1 readme.gentoo-r1 xdg

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"
SRC_URI="
	${CARGO_CRATE_URIS}
https://github.com/ankitects/anki/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
https://github.com/ankitects/anki-core-i18n/archive/${I18N_COMMIT}.tar.gz -> anki-core-i18n-${I18N_COMMIT}.tar.gz
https://github.com/ankitects/anki-desktop-ftl/archive/${QT_COMMIT}.tar.gz -> anki-desktop-ftl-${QT_COMMIT}.tar.gz
https://github.com/PIPIPIG233666/gentoo_pppig/releases/download/${P}/node-modules.tar.gz
"
LICENSE="AGPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0 ISC MIT
	MPL-2.0 Unicode-DFS-2016 ZLIB
"

SLOT="0"
KEYWORDS="~amd64"
IUSE="lto qt6"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
dev-libs/protobuf
sys-apps/yarn
net-libs/nodejs
"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		qt6? (
			>=dev-python/PyQt6-6.6.1[gui,svg,widgets,quick,${PYTHON_USEDEP}]
			>=dev-python/PyQt6-WebEngine-6.6.0[${PYTHON_USEDEP}]
		)
		!qt6? (
			~dev-python/PyQt5-5.15.10[gui,svg,widgets,${PYTHON_USEDEP}]
			~dev-python/PyQtWebEngine-5.15.6[${PYTHON_USEDEP}]
		)
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/send2trash[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/orjson[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flask-cors[${PYTHON_USEDEP}]
		dev-python/waitress[${PYTHON_USEDEP}]
	')
"
# from https://aur.archlinux.org/cgit/aur.git
PATCHES=(
	"${FILESDIR}/disable-git-checks.patch"
	"${FILESDIR}/no-update.patch"
	"${FILESDIR}/strip-formatter-deps.patch"
	"${FILESDIR}/strip-type-checking-deps.patch"
	"${FILESDIR}/node-drop-yarn-install.patch"
)

DOC_CONTENTS="Users with add-ons that still rely on Anki's Qt5 GUI can either switch
to ${CATEGORY}/${PN}[-qt6], or temporarily set an environment variable
ENABLE_QT5_COMPAT to 1 to have Anki install the previous compatibility code.
The latter option has additional runtime dependencies. Please take a look
at this package's 'optional runtime features' for a complete listing.
\n\nIn an early 2024 update, ENABLE_QT5_COMPAT will be removed, so this is not a
long-term solution.
\n\nAnki's user manual is located online at https://docs.ankiweb.net/
\nAnki's add-on developer manual is located online at
https://addon-docs.ankiweb.net/
"

src_prepare() {
	default
	# Build process wants .git/HEAD to be present. Workaround to be able to use tarballs
	# (together with disable-git-checks.patch)
	mkdir -p .git
	touch .git/HEAD
	sed -i "s/MY_REV/${ANKI_COMMIT}/" build/runner/src/build.rs

	# place translations in build dir
	rm -rf ftl/core-repo ftl/qt-repo || die
	mv "${WORKDIR}"/anki-core-i18n-${I18N_COMMIT} ftl/core-repo || die
	mv "${WORKDIR}"/anki-desktop-ftl-${QT_COMMIT} ftl/qt-repo || die

	# place node_modules in build dir
	mkdir -p out/node_modules || die
	mv "${WORKDIR}"/out/node_modules out/ || die
	ln -sf out/node_modules node_modules || die

	# mask pip-sync as we provide dependencies ourselves
	local venv="out/pyenv"
	${EPYTHON} -m venv --system-site-packages --without-pip "$venv"
	printf '#!/bin/bash\nexit 0' > "$venv/bin/pip-sync"
	chmod +x "$venv/bin/pip-sync"

	sed -i -e "s/updates=True/updates=False/" \
		qt/aqt/profiles.py || die

	# Anki's Qt detection mechanism falls back to Qt5 Python bindings, if Qt6
	# Python bindings don't get imported successfully.
	if ! use qt6; then
		sed -i "s/import PyQt6/raise ImportError/" aqt/qt/__init__.py || die
	fi
}

src_compile() {
	if use lto; then
		export RELEASE=2
	fi
	export CARGO_TARGET_DIR=out/rust
	export PROTOC_BINARY="${EPREFIX}/usr/bin/protoc"
	export PYTHON_BINARY="${EPREFIX}/usr/bin/python3"
	export NODE_BINARY="${EPREFIX}/usr/bin/node"
	export YARN_BINARY="${EPREFIX}/usr/bin/yarn"
	cargo build -p runner --release || die "cargo build failed"
	${CARGO_TARGET_DIR}/release/runner build || die "runner build failed"
}

src_install() {
	mkdir python
	rm -rf out/pylib/anki/_rsbridge.so || die
	if use lto; then
		cp ${CARGO_TARGET_DIR}/release-lto/librsbridge.so out/pylib/anki/_rsbridge.so || die
	else
		cp ${CARGO_TARGET_DIR}/release/librsbridge.so out/pylib/anki/_rsbridge.so || die
	fi

	cp -r pylib/anki/* out/pylib/anki || die
	cp -r out/pylib/anki python/anki || die

	cp -r qt/aqt python/aqt || die
	cp -r out/qt/_aqt/ python/_aqt || die

	doicon "qt/bundle/lin/${PN}.png"
	doicon "qt/bundle/lin/${PN}.xpm"
	domenu "qt/bundle/lin/${PN}.desktop"
	doman "qt/bundle/lin/${PN}.1"

	python_domodule python/{anki,{,_}aqt}
	printf "#!/usr/bin/python3\nimport sys;from aqt import run;sys.exit(run())" > runanki
	python_newscript runanki anki
	insinto /usr/share/mime/packages
	doins "qt/bundle/lin/${PN}.xml"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_pkg_postinst
	optfeature "LaTeX in cards" "app-text/texlive[extra] app-text/dvipng"
	optfeature "sound support" media-video/mpv media-video/mplayer
	optfeature "recording support" "media-sound/lame[frontend] dev-python/PyQt$(usex qt6 6 5)[multimedia]"
	optfeature "faster database operations" dev-python/orjson
	use qt6 && optfeature "compatibility with Qt5-dependent add-ons" dev-python/PyQt6[dbus,printsupport]
	use qt6 && optfeature "Vulkan driver" "media-libs/vulkan-loader dev-qt/qtbase[vulkan]
							  dev-qt/qtdeclarative:6[vulkan] dev-qt/qtwebengine:6[vulkan]"

	einfo "You can customize the LaTeX header for your cards to fit your needs:"
	einfo "Notes > Manage Note Types > [select a note type] > Options"
}

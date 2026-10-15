# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aead@0.5.2
	aes@0.8.4
	android_system_properties@0.1.6
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.102
	anyhow@1.0.104
	arrayvec@0.7.8
	askama@0.13.1
	askama@0.16.0
	askama_derive@0.13.1
	askama_derive@0.16.0
	askama_macros@0.16.0
	askama_parser@0.13.0
	askama_parser@0.16.0
	async-trait@0.1.89
	atomic-waker@1.1.2
	autocfg@1.5.1
	base64@0.22.1
	base64ct@1.8.3
	basic-toml@0.1.10
	bip39@2.2.2
	bit-set@0.8.0
	bit-vec@0.8.0
	bitcoin_hashes@0.14.101
	bitflags@2.13.1
	bitstream-io@4.10.0
	bitvec@1.1.1
	block-buffer@0.10.4
	bnum@0.12.1
	bumpalo@3.20.3
	bytes@1.12.1
	camino@1.2.5
	cargo-platform@0.3.2
	cargo-platform@0.3.3
	cargo_metadata@0.23.1
	cc@1.4.2
	cfg-if@1.0.4
	cfg_aliases@0.2.2
	chacha20@0.10.1
	chrono@0.4.45
	cipher@0.4.4
	clap@4.6.6
	clap_builder@4.6.6
	clap_derive@4.6.4
	clap_lex@1.1.0
	colorchoice@1.0.5
	const-oid@0.9.6
	convert_case@0.11.0
	core-foundation-sys@0.8.7
	cpufeatures@0.2.17
	cpufeatures@0.3.0
	crc-catalog@2.5.0
	crc@3.4.0
	crypto-common@0.1.7
	crypto_box@0.9.1
	crypto_secretbox@0.1.1
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.3
	deluxe-core@0.5.0
	deluxe-macros@0.5.0
	deluxe@0.5.0
	der@0.7.10
	digest@0.10.7
	displaydoc@0.2.7
	ed25519-dalek@2.2.0
	ed25519@2.2.3
	equivalent@1.0.2
	errno@0.3.14
	fastnum@0.7.4
	fastrand@2.5.0
	fiat-crypto@0.2.9
	find-msvc-tools@0.1.10
	fnv@1.0.7
	form_urlencoded@1.2.2
	fs-err@3.3.1
	funty@2.0.0
	futures-channel@0.3.34
	futures-core@0.3.34
	futures-executor@0.3.34
	futures-io@0.3.34
	futures-macro@0.3.34
	futures-sink@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	futures@0.3.31
	generic-array@0.14.7
	getrandom@0.2.17
	getrandom@0.3.4
	getrandom@0.4.3
	glob@0.3.4
	goblin@0.8.2
	hashbrown@0.17.1
	heck@0.4.1
	heck@0.5.0
	hex-conservative@0.2.2
	hex@0.4.3
	hmac@0.12.1
	http-body-util@0.1.5
	http-body@1.1.0
	http@1.5.0
	httparse@1.10.1
	hyper-rustls@0.27.9
	hyper-util@0.1.20
	hyper@1.11.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	icu_collections@2.2.0
	icu_locale_core@2.2.0
	icu_normalizer@2.2.0
	icu_normalizer_data@2.2.0
	icu_properties@2.2.0
	icu_properties_data@2.2.0
	icu_provider@2.2.0
	idna@1.1.0
	idna_adapter@1.2.2
	if_chain@1.0.3
	indexmap@2.14.0
	inout@0.1.4
	ipnet@2.12.1
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	js-sys@0.3.104
	libc@0.2.189
	libm@0.2.16
	linux-raw-sys@0.12.1
	litemap@0.8.2
	lock_api@0.4.14
	log@0.4.33
	lru-slab@0.1.2
	memchr@2.8.3
	minimal-lexical@0.2.1
	mio@1.2.2
	no_std_io2@0.9.4
	nom@7.1.3
	num-bigint@0.4.8
	num-integer@0.1.47
	num-traits@0.2.19
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	opaque-debug@0.3.1
	ordered-float@2.10.1
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	password-hash@0.5.0
	paste@1.0.15
	pbkdf2@0.12.2
	percent-encoding@2.3.2
	pin-project-lite@0.2.17
	pkcs8@0.10.2
	plain@0.2.3
	poly1305@0.8.0
	potential_utf@0.1.5
	ppv-lite86@0.2.21
	proc-macro-crate@1.3.1
	proc-macro-crate@3.5.0
	proc-macro2@1.0.107
	proptest@1.11.0
	quick-error@1.2.3
	quinn-proto@0.11.16
	quinn-udp@0.5.15
	quinn@0.11.11
	quote@1.0.47
	r-efi@5.3.0
	r-efi@6.0.0
	radium@0.7.0
	rand@0.10.2
	rand@0.9.5
	rand_chacha@0.9.0
	rand_core@0.10.1
	rand_core@0.6.4
	rand_core@0.9.5
	rand_pcg@0.10.2
	rand_xorshift@0.4.0
	redox_syscall@0.5.18
	regex-syntax@0.8.11
	reqwest@0.12.28
	ring@0.17.14
	rustc-hash@2.1.3
	rustc_version@0.4.1
	rustix@1.1.4
	rustls-pki-types@1.15.1
	rustls-webpki@0.103.14
	rustls@0.23.45
	rustversion@1.0.23
	rusty-fork@0.3.1
	ryu@1.0.23
	salsa20@0.10.2
	scopeguard@1.2.0
	scroll@0.12.0
	scroll_derive@0.12.1
	semver@1.0.28
	serde-aux@4.7.0
	serde-value@0.7.0
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.151
	serde_spanned@1.1.1
	serde_urlencoded@0.7.1
	sha2@0.10.9
	shlex@2.0.1
	signature@2.2.0
	similar@2.7.0
	siphasher@1.0.3
	slab@0.4.12
	smallvec@1.15.2
	smawk@0.3.3
	socket2@0.6.5
	spki@0.7.3
	stable_deref_trait@1.2.1
	static_assertions@1.1.0
	strsim@0.10.0
	strsim@0.11.1
	subtle@2.6.1
	syn@2.0.119
	syn@3.0.3
	sync_wrapper@1.0.2
	synstructure@0.13.2
	tap@1.0.1
	tempfile@3.27.0
	textwrap@0.16.2
	thiserror-impl@2.0.17
	thiserror-impl@2.0.20
	thiserror@2.0.17
	thiserror@2.0.20
	tinystr@0.8.3
	tinyvec@1.12.0
	tinyvec_macros@0.1.1
	tokio-rustls@0.26.4
	tokio@1.53.1
	toml@1.1.4+spec-1.1.0
	toml_datetime@0.6.11
	toml_datetime@1.1.1+spec-1.1.0
	toml_edit@0.19.15
	toml_edit@0.25.13+spec-1.1.0
	toml_parser@1.1.3+spec-1.1.0
	toml_writer@1.1.2+spec-1.1.0
	ton_core@0.1.4
	ton_macros@0.1.2
	topological-sort@0.2.2
	tower-http@0.6.11
	tower-layer@0.3.3
	tower-service@0.3.3
	tower@0.5.3
	tracing-core@0.1.36
	tracing@0.1.44
	try-lock@0.2.5
	typenum@1.20.1
	unarray@0.1.4
	unicode-ident@1.0.24
	unicode-linebreak@0.1.5
	unicode-normalization@0.1.25
	unicode-segmentation@1.13.3
	unicode-width@0.2.2
	uniffi@0.32.0
	uniffi_bindgen@0.32.0
	uniffi_core@0.32.0
	uniffi_internal_macros@0.32.0
	uniffi_macros@0.32.0
	uniffi_meta@0.32.0
	uniffi_pipeline@0.32.0
	uniffi_udl@0.32.0
	universal-hash@0.5.1
	untrusted@0.9.0
	url@2.5.7
	utf8_iter@1.0.4
	utf8parse@0.2.2
	version_check@0.9.5
	wait-timeout@0.2.1
	want@0.3.1
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.4+wasi-0.2.12
	wasm-bindgen-futures@0.4.77
	wasm-bindgen-macro-support@0.2.127
	wasm-bindgen-macro@0.2.127
	wasm-bindgen-shared@0.2.127
	wasm-bindgen@0.2.127
	web-sys@0.3.104
	web-time@1.1.0
	webpki-roots@1.0.9
	weedle2@5.0.0
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.52.0
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.5.40
	winnow@0.7.15
	winnow@1.0.4
	wit-bindgen@0.57.1
	writeable@0.6.3
	wyz@0.5.1
	yoke-derive@0.8.2
	yoke@0.8.3
	zerocopy-derive@0.8.56
	zerocopy@0.8.56
	zerofrom-derive@0.1.7
	zerofrom@0.1.8
	zeroize@1.9.0
	zeroize_derive@1.5.0
	zerotrie@0.2.4
	zerovec-derive@0.11.3
	zerovec@0.11.6
	zmij@1.0.23
"
# Updating the CRATES variable:
# ( export DISTDIR="$PWD/distfiles"; pycargoebuild && pycargoebuild bindgen/cpp/bindgen )
# ( inherit(){:;}; . ./wallet-engine-*.ebuild && echo "$CRATES" &&
# 	. ./uniffi-bindgen-cpp-*.ebuild && echo "$CRATES" ) | sort | uniq

RUST_MIN_VER="1.96.1"
inherit cargo flag-o-matic edo

DESCRIPTION="Cross-platform wallet engine for TON written in Rust (Telegram patchset)"
HOMEPAGE="https://github.com/i582/wallet-engine"

# Checking for updates:
# https://github.com/telegramdesktop/tdesktop/blob/dev/Telegram/build/docker/centos_env/Dockerfile
# 	(look for the git fetch line for wallet-engine)
# https://github.com/desktop-app/patches/blob/master/wallet-engine.patch
# 	(look at the most recent commit for this file)

# The PV of this package is the wallet-engine version followed by "_p" and the
# date of either the wallet-engine commit or the patch, whichever is most
# recent.

MY_PN="wallet-engine"
MY_PV="e59e0d89d7ee90c388bf36e3334c5b276f396697"
PATCHES_PV="82ed0c85bc1a1399a66b75ca7a978799c507e2ba"
SRC_URI="https://github.com/i582/wallet-engine/archive/${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV:0:7}.tar.gz
	https://raw.githubusercontent.com/desktop-app/patches/${PATCHES_PV}/wallet-engine.patch
		-> wallet-engine-telegram-${PATCHES_PV:0:7}.patch
	${CARGO_CRATE_URIS}"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

# Make sure this number changes when any function signature changes
SV="${PV//_p/.}"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0
	Unicode-3.0
"
# Dependent crate licenses (uniffi-bindgen-cpp)
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0/${SV}"
KEYWORDS="~amd64"

if [ ${PV} = 0.0.7_p20261002 ]; then
	# Failing tests
	RESTRICT+=" test"
fi

PATCHES=(
	"${DISTDIR}/wallet-engine-telegram-82ed0c8.patch"
)

src_compile() {
	local -Ix LDFLAGS
	append-ldflags -Wl,-soname,libwallet_engine-telegram.so.${SV}
	cargo_src_compile

	mkdir -p bindings/cpp || die
	cargo_env edo "${CARGO}" run \
		--manifest-path bindgen/cpp/bindgen/Cargo.toml --locked -- \
		--library --out-dir bindings/cpp \
		"$(cargo_target_dir)/libwallet_engine.so" || die
}

src_install() {
	einstalldocs
	newlib.so "$(cargo_target_dir)/libwallet_engine.so" libwallet_engine-telegram.so.${SV}
	dosym libwallet_engine-telegram.so.${SV} /usr/$(get_libdir)/libwallet_engine-telegram.so

	insinto /usr/include/wallet_engine-telegram
	doins bindings/cpp/*.hpp
	# The specific generated bindings must be compiled into the target project
	doins bindings/cpp/*.cpp
}

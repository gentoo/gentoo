# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.0
	anyhow@1.0.97
	attohttpc@0.25.0
	attohttpc@0.28.5
	bitflags@2.9.0
	bytes@1.10.0
	cc@1.2.16
	cfg-if@1.0.0
	core-foundation-sys@0.8.7
	core-foundation@0.9.4
	crc32fast@1.4.2
	darling@0.14.4
	darling_core@0.14.4
	darling_macro@0.14.4
	dbus@0.9.7
	derive_is_enum_variant@0.1.1
	dirs-sys@0.4.1
	dirs@5.0.1
	displaydoc@0.2.5
	enum-kinds@0.5.1
	equivalent@1.0.2
	errno@0.3.10
	fastrand@2.3.0
	flate2@1.1.0
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.1
	from_variants@1.0.2
	from_variants_impl@1.0.2
	getrandom@0.2.15
	getrandom@0.3.1
	hashbrown@0.15.2
	heck@0.3.3
	http@0.2.12
	http@1.2.0
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	ident_case@1.0.1
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@2.7.1
	itoa@1.0.15
	libc@0.2.170
	libdbus-sys@0.2.5
	libredox@0.1.3
	linux-raw-sys@0.4.15
	listenbrainz@0.8.1
	litemap@0.7.5
	log@0.4.26
	md5@0.7.0
	memchr@2.7.4
	miniz_oxide@0.8.5
	mpris@2.0.1
	native-tls@0.2.14
	once_cell@1.20.3
	openssl-macros@0.1.1
	openssl-probe@0.1.6
	openssl-sys@0.9.106
	openssl@0.10.71
	option-ext@0.2.0
	percent-encoding@2.3.1
	pkg-config@0.3.32
	proc-macro2@1.0.94
	quote@0.3.15
	quote@1.0.39
	redox_users@0.4.6
	rpassword@7.3.1
	rtoolbox@0.0.2
	rustfm-scrobble-proxy@2.0.0
	rustix@0.38.44
	ryu@1.0.20
	schannel@0.1.27
	security-framework-sys@2.14.0
	security-framework@2.11.1
	serde@1.0.218
	serde_derive@1.0.218
	serde_json@1.0.140
	serde_spanned@0.6.8
	serde_urlencoded@0.7.1
	shlex@1.3.0
	smallvec@1.14.0
	stable_deref_trait@1.2.0
	strsim@0.10.0
	syn@0.11.11
	syn@1.0.109
	syn@2.0.99
	synom@0.11.3
	synstructure@0.13.1
	tempfile@3.17.1
	thiserror-impl@1.0.69
	thiserror-impl@2.0.12
	thiserror@1.0.69
	thiserror@2.0.12
	tinystr@0.7.6
	toml@0.8.20
	toml_datetime@0.6.8
	toml_edit@0.22.24
	unicode-ident@1.0.18
	unicode-segmentation@1.12.0
	unicode-xid@0.0.4
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	vcpkg@0.2.15
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.7.3
	wit-bindgen-rt@0.33.0
	wrapped-vec@0.3.0
	write16@1.0.0
	writeable@0.5.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerovec-derive@0.10.3
	zerovec@0.10.4
"

inherit cargo systemd

DESCRIPTION="MPRIS music scrobbler daemon"
HOMEPAGE="https://github.com/InputUsername/rescrobbled"
SRC_URI="https://github.com/InputUsername/rescrobbled/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-libs/openssl:=
	sys-apps/dbus"

QA_FLAGS_IGNORED="/usr/bin/rescrobbled"

src_install() {
	cargo_src_install
	einstalldocs

	systemd_dounit "${S}"/rescrobbled.service

	dodoc "${FILESDIR}"/config.toml
	docompress -x "/usr/share/doc/${PF}/config.toml"

	dodoc -r "${S}"/filter-script-examples
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Sample configuration file has been installed to "
		elog "  /usr/share/doc/rescrobbled-${PVR}/config.toml"
		elog ""
		elog "Use the sample, or launch rescrobbled to create a new empty one."
		elog ""
	fi
}

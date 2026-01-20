# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.89.0"

inherit cargo

DESCRIPTION="A new type of shell, written in Rust"
HOMEPAGE="https://www.nushell.sh"
SRC_URI="https://github.com/nushell/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/nushell/releases/download/${PV}/${P}-crates.tar.xz"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 BSD Boost-1.0 CC-PD CC0-1.0 ISC MIT MPL-2.0 MPL-2.0
	Unicode-DFS-2016 ZLIB
"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv"
IUSE="mcp plugins system-clipboard X"

DEPEND="
	dev-libs/openssl:0=
	dev-db/sqlite:3=
	system-clipboard? (
		X? (
			x11-libs/libX11
			x11-libs/libxcb
		)
	)
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

RESTRICT+=" test"

QA_FLAGS_IGNORED="usr/bin/nu.*"

src_prepare() {
	use plugins || eapply "${FILESDIR}/${PN}-dont-build-plugins-from-106.patch"
	default
}

src_configure() {
	# high magic to allow system-libs
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
	export OPENSSL_NO_VENDOR=true
	export PKG_CONFIG_ALLOW_CROSS=1

	local myfeatures=(
		$(usev mcp)
		network
		plugin
		native-tls
		sqlite
		$(usev system-clipboard)
		trash-support
	)

	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile --workspace
}

src_install() {
	cargo_src_install
	if use plugins ; then
		# Clear features to compile plugins
		local myfeatures=()
		cargo_src_configure

		cargo_src_install --path crates/nu_plugin_custom_values
		cargo_src_install --path crates/nu_plugin_example
		cargo_src_install --path crates/nu_plugin_formats
		cargo_src_install --path crates/nu_plugin_gstat
		cargo_src_install --path crates/nu_plugin_inc
		cargo_src_install --path crates/nu_plugin_polars
		cargo_src_install --path crates/nu_plugin_query
		cargo_src_install --path crates/nu_plugin_stress_internals
	fi
	local DOCS=( README.md )
	einstalldocs
}

pkg_postinst() {
	if use plugins ; then
		einfo "The plugins are installed alongside the main 'nu' binary."
		einfo "Visit https://www.nushell.sh/book/plugins.html#adding-a-plugin"
		einfo "for more information on how to use plugins."
	fi
}

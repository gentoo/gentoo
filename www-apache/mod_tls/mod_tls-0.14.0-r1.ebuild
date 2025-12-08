# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit apache-module autotools

DESCRIPTION="A module that uses rustls to provide a memory safe TLS implementation in Rust."
HOMEPAGE="https://github.com/icing/mod_tls"
SRC_URI="https://github.com/icing/mod_tls/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ssl"

RDEPEND="
	|| ( =net-libs/rustls-ffi-0.15* =net-libs/rustls-ffi-0.14* )
	>=www-servers/apache-2.4.48[-apache2_modules_tls(-)]
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-werror.patch" )

need_apache2_4

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	default
}

src_install() {
	default

	APACHE2_MOD_DEFINE="TLS"
	insinto "${APACHE_MODULES_CONFDIR}"
	newins "${FILESDIR}/mod_tls.conf" "41_mod_tls.conf"
}

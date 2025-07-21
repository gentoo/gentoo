# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit apache-module autotools

DESCRIPTION="MaxMind DB Apache Module"
HOMEPAGE="https://maxmind.github.io/mod_maxminddb/"
SRC_URI="https://github.com/maxmind/mod_maxminddb/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libmaxminddb:="
RDEPEND="${DEPEND}"

need_apache2_4

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	# skipping this results in:
	# Cannot load modules/mod_maxminddb.so into server:
	# /usr/lib64/apache2/modules/mod_maxminddb.so: undefined symbol: MMDB_aget_value
	# because mod_maxminddb.so is not linked with libmaxminddb
	emake
}

src_install() {
	APACHE2_MOD_CONF="70_${PN}"
	APACHE2_MOD_DEFINE="MAXMINDDB"
	APACHE_MODULESDIR="/usr/$(get_libdir)/apache2/modules"

	apache-module_src_install
}

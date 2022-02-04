# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module depend.apache

DESCRIPTION="Apache module for cookie based authentication"
HOMEPAGE="http://www.openfusion.com.au/labs/mod_auth_tkt/"
SRC_URI="http://www.openfusion.com.au/labs/dist/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-lang/perl"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTH_TKT"

DOCFILES="README"

# test suite is completely broken
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-apache-2.4.patch
)

need_apache2

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}

src_configure() {
	./configure --apachever=2.2 --apxs=${APXS} || die
}

src_compile() {
	emake
}

src_install() {
	apache-module_src_install

	pod2man --section=5 --release=${PV} doc/${PN}.{pod,5} || die
	doman doc/${PN}.5
}

pkg_postinst() {
	apache-module_pkg_postinst
	einfo "See 'man mod_auth_tkt' for details on the individual directives."
	einfo "Remember to change shared secret 'TKTAuthSecret' before using!"
	einfo
}

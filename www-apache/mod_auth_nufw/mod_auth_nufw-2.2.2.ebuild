# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools confutils apache-module

DESCRIPTION="A NuFW authentication module for Apache"
HOMEPAGE="http://software.inl.fr/trac/wiki/EdenWall/mod_auth_nufw"
SRC_URI="http://software.inl.fr/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mysql postgres"

DEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql[server] )"
RDEPEND="${DEPEND}"

APACHE2_MOD_FILE="mod_auth_nufw.so"
APACHE2_MOD_CONF="50_${PN}"
APACHE2_MOD_DEFINE="AUTH_NUFW"

DOCFILES="doc/mod_auth_nufw.html"

need_apache2_2

pkg_setup() {
	confutils_require_one mysql postgres
}

src_prepare() {
	eautoreconf
}

src_configure() {
	CPPFLAGS="-I$(/usr/bin/apr-1-config --includedir) ${CPPFLAGS}" \
	econf \
		--with-apache22 \
		$(use_with mysql) \
		|| die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit apache-module eutils

DESCRIPTION="Apache 2 module enabling HTTP authentication against MySQL databases. "
HOMEPAGE="http://packages.debian.org/source/mod-auth-mysql"
DEBIAN_PV="13"
MY_P="${PN}_${PV/-/_}"
DEBIAN_URI="mirror://debian/pool/main/${PN:0:1}/${PN}"
DEBIAN_PATCH="${MY_P}-${DEBIAN_PV}.diff.gz"
DEBIAN_SRC="${MY_P}.orig.tar.gz"
SRC_URI="${DEBIAN_URI}/${DEBIAN_SRC} ${DEBIAN_URI}/${DEBIAN_PATCH}"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/mysql"
RDEPEND="${DEPEND}
		!www-apache/mod_auth_mysql"

APACHE2_MOD_FILE="${S}/apache2_mod_auth_mysql.so"
APACHE2_MOD_CONF="12_${PN//-/_}"
APACHE2_MOD_DEFINE="AUTH_MYSQL"

DOCFILES="USAGE DIRECTIVES"

need_apache2_2

src_unpack() {
	unpack "${DEBIAN_SRC}"
}

src_prepare() {
	EPATCH_OPTS="-p1" epatch "${DISTDIR}"/"${DEBIAN_PATCH}"
	for i in $(<"${S}"/debian/patches/00list) ; do
		epatch "${S}"/debian/patches/${i}*
	done
	epatch_user
}

src_configure() {
	econf \
		--enable-apache2 \
		--disable-apache13 \
		--with-apxs2=/usr/sbin/apxs2
}

src_compile() {
	default
}

src_install() {
	apache-module_src_install
}

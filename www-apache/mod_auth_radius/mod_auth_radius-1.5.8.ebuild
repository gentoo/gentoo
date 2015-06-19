# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_auth_radius/mod_auth_radius-1.5.8.ebuild,v 1.3 2014/08/10 20:14:22 slyfox Exp $

EAPI="5"

inherit apache-module eutils

DESCRIPTION="Radius authentication for Apache"
HOMEPAGE="http://freeradius.org/mod_auth_radius/"
SRC_URI="ftp://ftp.freeradius.org/pub/radius/${P}.tar"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

APACHE2_MOD_FILE=".libs/mod_auth_radius-2.0.so"
APACHE2_MOD_DEFINE="AUTH_RADIUS"

APXS2_ARGS="-c ${PN}-2.0.c"

DOCFILES="README"

need_apache2

src_prepare() {
	epatch "${FILESDIR}/${PV}-includes.patch"
	if has_version ">=www-servers/apache-2.4"; then
		epatch "${FILESDIR}/${PV}-remote_ip-obsolete.patch"
	fi
}

src_compile() {
	apache-module_src_compile
}

src_install() {
	apache-module_src_install
}

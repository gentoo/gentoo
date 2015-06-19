# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_auth_xradius/mod_auth_xradius-0.4.6.ebuild,v 1.2 2014/08/10 20:14:33 slyfox Exp $

EAPI="5"

inherit autotools eutils

DESCRIPTION="Radius authentication for Apache"
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_auth_xradius/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

DOCFILES="README"

src_prepare() {
	epatch "${FILESDIR}/${PV}-obsolete-autotools-syntax.diff"
	if has_version ">=www-servers/apache-2.4"; then
		epatch "${FILESDIR}/${PV}-apache24-api-changes.diff"
	fi
	AT_M4DIR="m4" eautoreconf
}

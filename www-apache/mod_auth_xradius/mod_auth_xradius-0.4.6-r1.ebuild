# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

DESCRIPTION="Radius authentication for Apache"
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_auth_xradius/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

DEPEND="www-servers/apache"
DOCFILES="README"

src_prepare() {
	epatch "${FILESDIR}/${PV}-obsolete-autotools-syntax.diff"
	epatch "${FILESDIR}/${PV}-fallback-support.diff"
	if has_version ">=www-servers/apache-2.4"; then
		epatch "${FILESDIR}/${PV}-apache24-api-changes.diff"
	fi
	AT_M4DIR="m4" eautoreconf
}

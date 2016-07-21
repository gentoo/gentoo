# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

DESCRIPTION="A realtime Apache log analyzer"
HOMEPAGE="http://www.webta.org/projects/apachetop"
SRC_URI="http://www.webta.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc sparc x86"
IUSE="fam pcre"

RDEPEND="
	fam? ( virtual/fam )
	pcre? ( dev-libs/libpcre )
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc41.patch
	epatch "${FILESDIR}"/${P}-configure.patch
	epatch "${FILESDIR}"/${P}-maxpathlen.patch
	epatch "${FILESDIR}"/${P}-ac_config_header.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-logfile=/var/log/apache2/access_log \
		--without-adns \
		$(use_with fam) \
		$(use_with pcre)
}

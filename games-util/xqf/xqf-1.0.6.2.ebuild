# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="A server browser for many FPS games (frontend for qstat)"
HOMEPAGE="http://xqf.github.io/en/"
SRC_URI="https://github.com/XQF/xqf/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="bzip2 geoip nls"

RDEPEND="x11-libs/gtk+:2
	>=games-util/qstat-2.11
	nls? ( virtual/libintl )
	geoip? ( dev-libs/geoip )
	bzip2? ( app-arch/bzip2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${P}

# bug #288853
src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-zlib-1.2.5.1-compile-fix.patch
	sed -i \
		-e '/Icon/s/.png//' \
		xqf.desktop.in || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable geoip) \
		$(use_enable bzip2)
}

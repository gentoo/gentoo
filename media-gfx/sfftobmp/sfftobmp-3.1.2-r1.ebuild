# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sfftobmp/sfftobmp-3.1.2-r1.ebuild,v 1.4 2013/09/25 17:30:24 ago Exp $

EAPI=5
inherit autotools eutils flag-o-matic

MY_P=${PN}${PV//./_}

DESCRIPTION="sff to bmp converter"
HOMEPAGE="http://sfftools.sourceforge.net/"
SRC_URI="mirror://sourceforge/sfftools/${MY_P}_src.zip"

LICENSE="HPND MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"
IUSE=""

RDEPEND=">=dev-libs/boost-1.49
	media-libs/tiff:0
	virtual/jpeg:0"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.1.1-gcc44-and-boost-1_37.patch \
		"${FILESDIR}"/${PN}-3.1.2-boost_fs3.patch
	append-cppflags -DBOOST_FILESYSTEM_VERSION=3
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc doc/{changes,credits,readme}
}

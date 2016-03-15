# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="IVTV utilities for Hauppauge PVR PCI cards"
HOMEPAGE="http://www.ivtvdriver.org/"
SRC_URI="http://dl.ivtvdriver.org/ivtv/archive/1.4.x/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="perl"

DEPEND="!media-tv/ivtv"
RDEPEND="${DEPEND}
	media-tv/v4l-utils
	perl? (
		dev-perl/Video-Frequencies
		dev-perl/Video-ivtv
		dev-perl/Config-IniFiles
		virtual/perl-Getopt-Long
		dev-perl/Tk
		)"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.4.0-gentoo.patch \
		"${FILESDIR}"/${PN}-1.4.1-overflow.patch
}

src_compile() {
	tc-export CC CXX
	emake
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc ChangeLog README doc/*

	if use perl; then
		dobin utils/perl/*.pl
		dodoc utils/perl/README.ptune
	fi
}

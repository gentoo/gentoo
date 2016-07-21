# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="a C++ library for loading Gigasampler files and DLS (Downloadable Sounds) Level 1/2 files"
HOMEPAGE="http://www.linuxsampler.org/libgig/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND=">=media-libs/libsndfile-1.0.2
	>=media-libs/audiofile-0.2.3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_compile() {
	emake

	if use doc ; then
		emake docs
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO

	if use doc ; then
		dohtml -r doc/html/*
	fi
}

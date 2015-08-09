# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils

DESCRIPTION="A software synthesizer based on ZynAddSubFX"
HOMEPAGE="http://yoshimi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/mini-xml-2.5
	>=media-libs/alsa-lib-1.0.17
	media-libs/fontconfig
	media-libs/libsndfile
	>=media-sound/jack-audio-connection-kit-0.115.6
	sci-libs/fftw:3.0
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/fltk:1[opengl]"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig"

S=${WORKDIR}/${P}/src

DOCS="../Changelog"

src_prepare() {
	sed -i \
		-e '/set (CMAKE_CXX_FLAGS_RELEASE/d' \
		CMakeLists.txt || die

	EPATCH_OPTS="-d .." epatch "${FILESDIR}"/${PN}-1.1.0-desktop-version.patch
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/yoshimi/yoshimi-1.0.0.ebuild,v 1.1 2012/07/16 06:50:12 radhermit Exp $

EAPI=4
inherit cmake-utils

DESCRIPTION="A software synthesizer based on ZynAddSubFX"
HOMEPAGE="http://yoshimi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-libs/zlib
	media-libs/fontconfig
	x11-libs/fltk:1[opengl]
	sci-libs/fftw:3.0
	>=dev-libs/mini-xml-2.5
	>=media-libs/alsa-lib-1.0.17
	>=media-sound/jack-audio-connection-kit-0.115.6
	media-libs/libsndfile"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}/src

DOCS="../${PV}.notes"

src_prepare() {
	sed -i \
		-e '/set (CMAKE_CXX_FLAGS_RELEASE/d' \
		CMakeLists.txt || die
}

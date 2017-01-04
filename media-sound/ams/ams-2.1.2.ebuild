# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic qmake-utils

DESCRIPTION="Alsa Modular Software Synthesizer"
HOMEPAGE="http://alsamodular.sourceforge.net"
SRC_URI="mirror://sourceforge/alsamodular/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-libs/ladspa-sdk
	media-libs/libclalsadrv
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	sci-libs/fftw:3.0=
	!dev-ruby/amrita"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-2.1.2-fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# C++11/14 fails:
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=811645
	append-cxxflags -std=gnu++98
	econf \
		--disable-nsm \
		--enable-qt5 \
		MOC="$(qt5_get_bindir)/moc" \
		LUPDATE="$(qt5_get_bindir)/lupdate" \
		LRELEASE="$(qt5_get_bindir)/lrelease"
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

DESCRIPTION="a software musical instrument and audio synthesizer"
HOMEPAGE="http://dinisnoise.org/"
SRC_URI="http://din.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/tcl:0=
	media-libs/liblo
	media-sound/jack-audio-connection-kit
	net-libs/libircclient
	sci-libs/fftw:3.0
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-tcl.patch
	epatch "${FILESDIR}"/${P}-desktop.patch

	# force script to be regenerated so it uses the right data path
	rm data/checkdotdin || die

	eautoreconf
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0"

inherit autotools eutils toolchain-funcs wxwidgets

DESCRIPTION="Analyse your audio files by showing their spectrogram"
HOMEPAGE="http://www.spek-project.org/"
SRC_URI="https://github.com/alexkay/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libav"

RDEPEND="
	libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:0= )
	x11-libs/wxGTK:${WX_GTK_VER}[X]
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	>=sys-devel/gcc-4.7
	sys-devel/gettext
"

src_prepare() {
	need-wxwidgets unicode
	
	if [ $(gcc-major-version) -lt "4" ] ; then
		die "You need to activate at least gcc:4.7"
	fi
	if [ $(gcc-major-version) -eq "4" -a $(gcc-minor-version) -lt "7" ] ; then
		die "You need to activate at least gcc:4.7"
	fi

	epatch \
		"${FILESDIR}"/${PN}-0.8.1-disable-updates.patch \
		"${FILESDIR}"/${P}-replace-gnu+11-with-c++11.patch \
		"${FILESDIR}"/${P}-stdlib.patch
	eautoreconf
}

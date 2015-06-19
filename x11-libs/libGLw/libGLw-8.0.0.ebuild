# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libGLw/libGLw-8.0.0.ebuild,v 1.7 2014/03/26 12:02:27 zlogene Exp $

EAPI=4

MY_P=glw-"${PV}"

inherit autotools-utils

DESCRIPTION="Mesa GLw library"
HOMEPAGE="http://mesa3d.sourceforge.net/"
SRC_URI="ftp://ftp.freedesktop.org/pub/mesa/glw/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+motif static-libs"

RDEPEND="
	!media-libs/mesa[motif]
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/motif
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

src_configure() {
	local myeconfargs=(
		--enable-motif
		)
	autotools-utils_src_configure
}

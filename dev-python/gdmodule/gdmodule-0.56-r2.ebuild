# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python extensions for gd"
HOMEPAGE="https://github.com/Solomoriah/gdmodule"
SRC_URI="http://newcenturycomputers.net/projects/download.cgi/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~ppc-macos ~x86-linux"
IUSE="jpeg png truetype xpm"

RDEPEND="
	media-libs/gd[jpeg?,png?,truetype?,xpm?]
	media-libs/giflib
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0 )
	truetype? ( media-libs/freetype:2 )
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fix-libs.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all
	mv Setup.py setup.py  || die

	# append unconditionally because it is enabled id media-libs/gd by default
	append-cppflags -DHAVE_LIBGIF

	use jpeg && append-cppflags -DHAVE_LIBJPEG
	use png && append-cppflags -DHAVE_LIBPNG
	use truetype && append-cppflags -DHAVE_LIBFREETYPE
	use xpm && append-cppflags -DHAVE_LIBXPM
}

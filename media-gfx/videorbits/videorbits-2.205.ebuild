# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="a collection of programs for creating high dynamic range images"
HOMEPAGE="http://comparametric.sourceforge.net/"
SRC_URI="mirror://sourceforge/comparametric/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	sys-libs/zlib
	media-libs/libpng:0=
	virtual/jpeg:0
	sci-libs/fftw:2.1
	media-libs/netpbm"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.201-libpng15.patch"
	"${FILESDIR}/${P}-qa-implicit-declarations.patch"
	"${FILESDIR}/${P}-fix-buildsystem.patch"
)
DOCS=( AUTHORS README README.MORE )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

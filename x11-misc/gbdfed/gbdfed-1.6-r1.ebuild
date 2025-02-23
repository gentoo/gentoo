# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="gbdfed Bitmap Font Editor"
HOMEPAGE="http://sofia.nmsu.edu/~mleisher/Software/gbdfed/"
SRC_URI="http://sofia.nmsu.edu/~mleisher/Software/gbdfed/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=media-libs/freetype-2
	>=x11-libs/gtk+-2.6:2
	x11-libs/libX11
	x11-libs/pango"
DEPEND="${RDEPEND}"

PATCHES=(
	# bug 248562
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-c23.patch
)

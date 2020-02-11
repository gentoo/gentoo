# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C64 SID player"
HOMEPAGE="http://sidplay2.sourceforge.net/"
SRC_URI="mirror://sourceforge/sidplay2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ~sparc x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="media-libs/libsidplay:2"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-gcc44.patch"
)

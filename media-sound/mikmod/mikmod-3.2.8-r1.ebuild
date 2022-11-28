# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A console MOD-Player based on libmikmod"
HOMEPAGE="http://mikmod.sourceforge.net/"
SRC_URI="mirror://sourceforge/mikmod/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86"

DEPEND="
	>=media-libs/libmikmod-3.3
	>=sys-libs/ncurses-5.7-r7:=
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-macro-strict-prototypes.patch
)

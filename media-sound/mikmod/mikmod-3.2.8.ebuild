# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A console MOD-Player based on libmikmod"
HOMEPAGE="http://mikmod.sourceforge.net/"
SRC_URI="mirror://sourceforge/mikmod/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ~sparc x86"
IUSE=""

DEPEND="
	>=media-libs/libmikmod-3.3
	>=sys-libs/ncurses-5.7-r7:0="
RDEPEND="${DEPEND}"

DOCS=( AUTHORS NEWS README )

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="nuoveXT2 iconset"
HOMEPAGE="https://lxde.org/"
SRC_URI="https://downloads.sourceforge.net/lxde/LXDE%20Icon%20Theme/${P}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"
IUSE=""

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

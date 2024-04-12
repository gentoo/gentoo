# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Monospace font based on Artwiz Snap with bold and versions with status icons"
HOMEPAGE="https://sourceforge.net/projects/osnapfont"
SRC_URI="https://downloads.sourceforge.net/osnapfont/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~loong ~x86"
IUSE=""

FONT_SUFFIX="pcf"

DOCS=( README.ohsnap )

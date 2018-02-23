# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="A sans-serif monotype font for code listings"
HOMEPAGE="https://fonts.google.com/specimen/Inconsolata"
SRC_URI="https://dev.gentoo.org/~jstein/dist/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${WORKDIR}/${P}"

# Only installs fonts
RESTRICT="binchecks strip test"

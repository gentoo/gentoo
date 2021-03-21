# Copyright 2008-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Sans-serif monotype font for code listings"
HOMEPAGE="https://fonts.google.com/specimen/Inconsolata?preview.text_type=custom"
SRC_URI="https://dev.gentoo.org/~jstein/dist/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc x86 ~ppc-macos ~x64-macos"
IUSE=""

# Only installs fonts
RESTRICT="binchecks strip test"

FONT_SUFFIX="ttf"

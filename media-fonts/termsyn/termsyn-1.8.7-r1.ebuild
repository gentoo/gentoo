# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Monospaced font based on terminus and tamsyn"
HOMEPAGE="https://sourceforge.net/projects/termsyn/"
SRC_URI="https://downloads.sourceforge.net/termsyn/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~loong"

FONT_SUFFIX="pcf"

src_install() {
	font_src_install
	insinto /usr/share/consolefonts
	doins *.psfu
}

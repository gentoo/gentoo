# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Bitstream Vera font family"
HOMEPAGE="https://www.gnome.org/fonts/"
SRC_URI="mirror://gnome/sources/ttf-bitstream-vera/${PV}/${P}.tar.bz2"

LICENSE="BitstreamVera"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

DOCS="COPYRIGHT.TXT README.TXT RELEASENOTES.TXT"
FONT_SUFFIX="ttf"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="VLGothic"

DESCRIPTION="Japanese TrueType font from Vine Linux"
HOMEPAGE="http://vlgothic.dicey.org/"
SRC_URI="mirror://sourceforge.jp/${PN}/73361/${MY_PN}-${PV}.tar.xz"

# M+ FONTS -> mplus-fonts
# sazanami -> BSD-2
LICENSE="vlgothic mplus-fonts BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~ia64 ~loong ~ppc ppc64 ~riscv sparc x86"
IUSE=""
RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_PN}"

DOCS="Changelog README*"

FONT_SUFFIX="ttf"

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="VLGothic"

DESCRIPTION="Japanese TrueType font from Vine Linux"
HOMEPAGE="http://vlgothic.dicey.org/"
SRC_URI="mirror://sourceforge.jp/${PN}/62375/${MY_PN}-${PV}.tar.bz2"

# M+ FONTS -> mplus-fonts
# sazanami -> BSD-2
LICENSE="vlgothic mplus-fonts BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~ia64 ppc ppc64 sparc x86"

S="${WORKDIR}/${MY_PN}"

DOCS="Changelog README*"
FONT_S="${S}"
FONT_SUFFIX="ttf"

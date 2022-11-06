# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="CharisSIL"
inherit font

DESCRIPTION="Serif typeface for Roman and Cyrillic languages"
HOMEPAGE="https://software.sil.org/charis/"
SRC_URI="https://software.sil.org/downloads/r/charis/${MY_PN}-${PV}.zip -> ${P}.zip"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~loong ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-macos"

BDEPEND="app-arch/unzip"

# DOCS=( OFL-FAQ.txt documentation/* )

FONT_SUFFIX="ttf"

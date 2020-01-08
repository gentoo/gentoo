# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Fonts for the Tibetan and Himalayan languages"
HOMEPAGE="http://www.thdl.org/"
SRC_URI="mirror://gentoo/TibetanMachineUnicodeFont-${PV}.zip"
#Original retrieved from:
#https://collab.itc.virginia.edu/access/content/group/26a34146-33a6-48ce-001e-f16ce7908a6a/Tibetan%20Fonts/Tibetan%20Unicode%20Fonts/TibetanMachineUnicodeFont.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

DOCS="ReadMe.txt"
FONT_S="${S}"
FONT_SUFFIX="ttf"

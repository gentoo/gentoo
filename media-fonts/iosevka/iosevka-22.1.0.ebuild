# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Slender typeface for code, from code"
HOMEPAGE="https://typeof.net/Iosevka/"
SRC_URI="https://github.com/be5invis/Iosevka/releases/download/v${PV}/super-ttc-${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttc"

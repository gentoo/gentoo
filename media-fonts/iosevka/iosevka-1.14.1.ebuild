# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Slender typeface for code, from code"
HOMEPAGE="http://be5invis.github.io/Iosevka"
SRC_URI="https://github.com/be5invis/${PN}/releases/download/v${PV}/01-${P}.zip
https://github.com/be5invis/${PN}/releases/download/v${PV}/02-${PN}-term-${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~arm64 ~ppc64"

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_S="${S}/ttf"
FONT_SUFFIX="ttf"

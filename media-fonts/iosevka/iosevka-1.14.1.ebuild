# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Slender typeface for code, from code"
HOMEPAGE="https://typeof.net/Iosevka/"
SRC_URI="https://github.com/be5invis/${PN}/releases/download/v${PV}/01-${P}.zip
https://github.com/be5invis/${PN}/releases/download/v${PV}/02-${PN}-term-${PV}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

BDEPEND="app-arch/unzip"

FONT_S="${S}/ttf"
FONT_SUFFIX="ttf"

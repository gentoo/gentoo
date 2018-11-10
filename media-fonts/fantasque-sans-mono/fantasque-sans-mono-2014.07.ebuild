# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="Functional programming font designed with some handwriting-like fuzziness"
HOMEPAGE="http://openfontlibrary.org/en/font/fantasque-sans-mono"
SRC_URI="http://openfontlibrary.org/assets/downloads/${PN}/db52617ba875d08cbd8e080ca3d9f756/${PN}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${S}/OTF"
FONT_SUFFIX="otf"
DOCS="README.md"

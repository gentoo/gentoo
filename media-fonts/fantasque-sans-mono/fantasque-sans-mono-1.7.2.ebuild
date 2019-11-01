# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Functional programming font designed with some handwriting-like fuzziness"
HOMEPAGE="https://github.com/belluzj/fantasque-sans"
SRC_URI="https://github.com/belluzj/fantasque-sans/releases/download/v${PV}/FantasqueSansMono-Normal.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S="${WORKDIR}"
FONT_S="${S}/OTF"
FONT_SUFFIX="otf"
DOCS="README.md"

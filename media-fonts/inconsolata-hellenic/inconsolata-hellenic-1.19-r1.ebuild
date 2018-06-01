# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Hellenisation of the wonderful, monospace, open/free font Inconsolata"
HOMEPAGE="http://www.cosmix.org/software/"
SRC_URI="http://www.cosmix.org/software/files/InconsolataHellenic.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_S=${S}
FONT_SUFFIX="ttf"

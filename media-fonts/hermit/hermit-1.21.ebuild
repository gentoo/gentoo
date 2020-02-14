# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="A monospace font designed to be clear, pragmatic and very readable"
HOMEPAGE="https://pcaro.es/p/hermit/"
SRC_URI="https://pcaro.es/d/otf-${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}
FONT_S="${S}"
FONT_SUFFIX="otf"

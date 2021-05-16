# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Font to help test writers develop predictable tests"
HOMEPAGE="https://github.com/Kozea/Ahem"
SRC_URI="https://github.com/Kozea/Ahem/archive/1.0.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/a/A}"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_SUFFIX="ttf"

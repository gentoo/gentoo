# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="A monospaced font developed for Windows Terminal"
HOMEPAGE="https://github.com/microsoft/cascadia-code"
SRC_URI="https://github.com/microsoft/cascadia-code/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

FONT_SUFFIX="ttf"

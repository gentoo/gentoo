# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="${PN}-v${PV}"

DESCRIPTION="An open-source Chinese font derived from Fontworks' Klee One"
HOMEPAGE="https://github.com/lxgw/LxgwWenKai"
SRC_URI="https://github.com/lxgw/LxgwWenKai/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~loong"

FONT_SUFFIX="ttf"

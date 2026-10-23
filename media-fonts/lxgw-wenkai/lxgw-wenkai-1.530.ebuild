# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="An open-source Chinese font derived from Fontworks' Klee One"
HOMEPAGE="https://github.com/lxgw/LxgwWenKai"
SRC_URI="https://github.com/lxgw/LxgwWenKai/releases/download/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~loong"

FONT_SUFFIX="ttf"

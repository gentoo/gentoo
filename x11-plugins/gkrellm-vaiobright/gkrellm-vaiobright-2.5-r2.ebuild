# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gkrellm-plugin

MY_P=${P/gkrellm-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Superslim VAIO LCD Brightness Control Plugin for Gkrellm"
SRC_URI="http://nerv-un.net/~dragorn/code/${MY_P}.tar.gz"
HOMEPAGE="http://nerv-un.net/~dragorn/"
IUSE=""

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"

RDEPEND="app-admin/gkrellm[X]"

PLUGIN_SO=vaiobright.so

PATCHES=(
	"${FILESDIR}"/${P}-textrel.patch
	"${FILESDIR}"/${P}-fixinfo.patch
)

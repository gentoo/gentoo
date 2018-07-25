# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin

MY_P=${P/gkrellm-/}

DESCRIPTION="Superslim VAIO LCD Brightness Control Plugin for Gkrellm"
SRC_URI="http://nerv-un.net/~dragorn/code/${MY_P}.tar.gz"
HOMEPAGE="http://nerv-un.net/~dragorn/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}
PATCHES=(
	"${FILESDIR}"/${P}-textrel.patch
	"${FILESDIR}"/${P}-fixinfo.patch
)

PLUGIN_SO=( vaiobright$(get_modname) )

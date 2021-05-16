# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

MY_P=${P/gkrellm-/}

DESCRIPTION="Superslim VAIO LCD Brightness Control Plugin for Gkrellm"
SRC_URI="http://nerv-un.net/~dragorn/code/${MY_P}.tar.gz"
HOMEPAGE="http://nerv-un.net/~dragorn/"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-textrel.patch
	"${FILESDIR}"/${P}-fixinfo.patch
)

PLUGIN_SO=( vaiobright$(get_modname) )

src_configure() {
	tc-export PKG_CONFIG
}

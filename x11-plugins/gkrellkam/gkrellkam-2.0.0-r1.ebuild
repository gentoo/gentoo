# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

MY_P=${P/-/_}

DESCRIPTION="an Image-Watcher-Plugin for GKrellM2"
HOMEPAGE="http://gkrellkam.sourceforge.net"
SRC_URI="mirror://sourceforge/gkrellkam/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc sparc x86"

RDEPEND="
	app-admin/gkrellm:2[X]
	net-misc/wget"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-r1-pkgconfig.patch
)

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	local PLUGIN_SO=( ${PN}2$(get_modname) )
	local PLUGIN_DOCS=( example.list )

	gkrellm-plugin_src_install
	doman gkrellkam-list.5
}

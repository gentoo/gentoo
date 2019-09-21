# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

MY_P=${P/-/_}

DESCRIPTION="an Image-Watcher-Plugin for GKrellM2"
SRC_URI="mirror://sourceforge/gkrellkam/${MY_P}.tar.gz"
HOMEPAGE="http://gkrellkam.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="
	 app-admin/gkrellm:2[X]
	 net-misc/wget"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	local PLUGIN_SO=( ${PN}2$(get_modname) )
	local PLUGIN_DOCS=( example.list )

	gkrellm-plugin_src_install
	doman gkrellkam-list.5
}

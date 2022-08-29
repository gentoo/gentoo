# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="Configurable Tray Icons for GKrellM"
HOMEPAGE="http://gkrellm.srcbox.net/Plugins.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-pkgconfig.patch
)

src_configure() {
	PLUGIN_SO=( trayicons$(get_modname) )
	default
}

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

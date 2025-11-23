# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

DESCRIPTION="XKB keyboard switcher for gkrellm2"
HOMEPAGE="http://tripie.sweb.cz/gkrellm/xkb/"
SRC_URI="http://tripie.sweb.cz/gkrellm/xkb/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-makefile.patch
	"${FILESDIR}"/${P}-r2-pkgconfig.patch
)

src_configure() {
	PLUGIN_SO=( xkb$(get_modname) )
	default
}

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="XKB keyboard switcher for gkrellm2"
HOMEPAGE="http://tripie.sweb.cz/gkrellm/xkb/"
SRC_URI="http://tripie.sweb.cz/gkrellm/xkb/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-makefile.patch )

PLUGIN_SO=( xkb$(get_modname) )

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

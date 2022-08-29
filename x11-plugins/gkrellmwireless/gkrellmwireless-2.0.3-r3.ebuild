# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A plugin for GKrellM that monitors your wireless network card"
HOMEPAGE="http://gkrellm.luon.net/gkrellmwireless.php"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.3-fix-build-system.patch
	"${FILESDIR}"/${PN}-2.0.3-r3-pkgconfig.patch
)

src_configure() {
	tc-export CC PKG_CONFIG

	PLUGIN_SO=( wireless$(get_modname) )
	default
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A plugin for GKrellM that monitors your wireless network card"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/gkrellmwireless.php"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}
PATCHES=( "${FILESDIR}"/${PN}-2.0.3-fix-build-system.patch )

src_configure() {
	tc-export CC

	PLUGIN_SO=( wireless$(get_modname) )
	default
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib

DESCRIPTION="GKrellm plugin for monitoring bluetooth (Linux BlueZ) adapters"
HOMEPAGE="http://gkrellm-bluez.sourceforge.net"
SRC_URI="mirror://sourceforge/gkrellm-bluez/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	app-admin/gkrellm:2[X]
	net-wireless/bluez
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-notheme.patch
)

PLUGIN_DOCS=( THEMING NEWS )

src_prepare() {
	default

	# Be a bit more future proof, bug #260948
	sed "s/-Werror//" -i src/Makefile.am src/Makefile.in || die
}

src_configure() {
	PLUGIN_SO=( src/.libs/gkrellmbluez$(get_modname) )

	default
}

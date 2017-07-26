# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gkrellm-plugin

DESCRIPTION="GKrellm plugin for monitoring bluetooth (Linux BlueZ) adapters"
SRC_URI="mirror://sourceforge/gkrellm-bluez/${P}.tar.gz"
HOMEPAGE="http://gkrellm-bluez.sourceforge.net"

RDEPEND="
	app-admin/gkrellm[X]
	net-wireless/bluez
"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""
SLOT="0"

PLUGIN_SO="src/.libs/gkrellmbluez.so"
PLUGIN_DOCS="THEMING NEWS"

src_prepare() {
	default
	# Be a bit more future proof, bug #260948
	sed "s/-Werror//" -i src/Makefile.am src/Makefile.in || die "sed failed"

	eapply "${FILESDIR}"/${P}-notheme.patch || die "Patch failed"
}

src_configure() {
	econf --disable-static
}

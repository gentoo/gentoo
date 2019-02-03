# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vcs-snapshot toolchain-funcs

DESCRIPTION="Implementation of xmpp message delivery receipts (XEP-0184) for Pidgin"
HOMEPAGE="https://github.com/noonien-d/pidgin-xmpp-receipts"
SRC_URI="https://github.com/noonien-d/pidgin-xmpp-receipts/archive/release_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="net-im/pidgin[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	GTK_PIDGIN_INCLUDES=$(pkg-config --cflags gtk+-2.0 pidgin)
	$(tc-getCC) ${LDFLAGS} -shared ${CFLAGS} -fpic ${GTK_PIDGIN_INCLUDES} -o ${PN/pidgin-/}.so ${PN/pidgin-/}.c || die
}

src_install() {
	PLUGIN_DIR_PIDGIN=$(pkg-config --variable=plugindir pidgin)
	dodir "${PLUGIN_DIR_PIDGIN}"
	insinto "${PLUGIN_DIR_PIDGIN}"
	doins ${PN/pidgin-/}.so
}

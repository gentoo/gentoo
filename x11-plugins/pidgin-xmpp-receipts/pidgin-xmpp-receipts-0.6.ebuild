# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Implementation of xmpp message delivery receipts (XEP-0184) for Pidgin"
HOMEPAGE="https://www.assembla.com/spaces/pidgin-xmpp-receipts/documents"
SRC_URI="https://www.assembla.com/spaces/pidgin-xmpp-receipts/documents/ckA6jCV5Kr4OkjacwqjQXA/download/ckA6jCV5Kr4OkjacwqjQXA -> ${P}.tar.gz"

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

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vcs-snapshot toolchain-funcs

DESCRIPTION="Implementation of xmpp message delivery receipts (XEP-0184) for Pidgin"
HOMEPAGE="https://github.com/noonien-d/pidgin-xmpp-receipts"
SRC_URI="https://github.com/noonien-d/pidgin-xmpp-receipts/archive/release_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="net-im/pidgin[gtk]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	GTK_PIDGIN_INCLUDES="$($(tc-getPKG_CONFIG) --cflags gtk+-2.0 pidgin)"
	$(tc-getCC) ${LDFLAGS} -shared ${CFLAGS} -fpic ${GTK_PIDGIN_INCLUDES} -o ${PN/pidgin-/}.so ${PN/pidgin-/}.c || die
}

src_install() {
	PLUGIN_DIR_PIDGIN=$($(tc-getPKG_CONFIG) --variable=plugindir pidgin)

	insinto "${PLUGIN_DIR_PIDGIN}"
	doins ${PN/pidgin-/}.so
}

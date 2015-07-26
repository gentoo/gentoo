# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/keybase/keybase-0.8.12.ebuild,v 1.1 2015/07/21 18:46:05 nicolasbock Exp $

EAPI=5

inherit eutils

DESCRIPTION="Client for keybase.io"
HOMEPAGE="https://keybase.io/"
SRC_URI="https://github.com/keybase/node-client/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	net-libs/nodejs
	app-crypt/gnupg"

src_unpack() {
	unpack "${P}.tar.gz"
	mv "node-client-${PV}" "${P}"
}

src_install() {
	dodoc CHANGELOG.md README.md SIGNED.md
	insinto "/opt/${PN}"
	doins -r package.json bin certs json lib node_modules sql
	dosym "${D}/opt/${PN}/bin/main.js" "${ROOT}/usr/bin/keybase"
	chmod 0755 "${D}/opt/${PN}/bin/main.js" || die
}

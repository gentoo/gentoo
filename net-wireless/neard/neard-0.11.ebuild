# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Near Field Communication (NFC) management daemon"
HOMEPAGE="https://01.org/linux-nfc/"
SRC_URI="mirror://kernel/linux/network/nfc/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="tools"

RDEPEND=">=dev-libs/glib-2.28:2
	dev-libs/libnl
	>=sys-apps/dbus-1.2.24"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable tools)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.rc ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

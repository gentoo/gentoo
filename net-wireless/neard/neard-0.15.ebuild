# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/neard/neard-0.15.ebuild,v 1.1 2015/05/18 08:55:28 monsieurp Exp $

EAPI=5

DESCRIPTION="Near Field Communication (NFC) management daemon"
HOMEPAGE="https://01.org/linux-nfc/"
SRC_URI="mirror://kernel/linux/network/nfc/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="tools systemd"

RDEPEND=">=dev-libs/glib-2.28:2
	dev-libs/libnl
	systemd? ( sys-apps/systemd:0 )
	>=sys-apps/dbus-1.2.24"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable systemd) $(use_enable tools)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.rc ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

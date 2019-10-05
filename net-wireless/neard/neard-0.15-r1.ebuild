# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Near Field Communication (NFC) management daemon"
HOMEPAGE="https://01.org/linux-nfc/"
SRC_URI="https://www.kernel.org/pub/linux/network/nfc/${P}.tar.xz"

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

	# Patch for this has been sent upstream.  Do it manually
	# to avoid having to rebuild autotools. #580876
	mv "${ED}"/usr/include/version.h "${ED}"/usr/include/near/ || die

	newinitd "${FILESDIR}"/${PN}.rc ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

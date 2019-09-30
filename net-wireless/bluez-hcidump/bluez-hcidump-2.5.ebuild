# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Bluetooth HCI packet analyzer"
HOMEPAGE="http://www.bluez.org/"
SRC_URI="https://www.kernel.org/pub/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86"
IUSE=""

RDEPEND=">=net-wireless/bluez-4.98"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

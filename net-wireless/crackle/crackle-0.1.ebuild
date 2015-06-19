# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/crackle/crackle-0.1.ebuild,v 1.4 2014/08/10 20:34:39 slyfox Exp $

EAPI=5

inherit eutils

DESCRIPTION="Crackle cracks BLE Encryption (AKA Bluetooth Smart)"
HOMEPAGE="http://lacklustre.net/projects/crackle/"
SRC_URI="http://lacklustre.net/projects/crackle/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/flags.patch
}

src_install() {
	dobin crackle
}

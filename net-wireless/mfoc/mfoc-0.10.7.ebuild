# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/mfoc/mfoc-0.10.7.ebuild,v 1.1 2013/12/20 01:13:43 mrueg Exp $

EAPI=5

inherit autotools

DESCRIPTION="Mifare Classic Offline Cracker"
HOMEPAGE="https://code.google.com/p/mfoc"
SRC_URI="https://mfoc.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/libnfc-1.7.0"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
}

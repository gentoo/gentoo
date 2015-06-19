# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-wijesekera/scim-wijesekera-0.3.3-r1.ebuild,v 1.3 2012/10/02 02:12:59 naota Exp $

EAPI=2

inherit autotools eutils

DESCRIPTION="Wijesekara keyboard for Sinhala input using scim"
HOMEPAGE="http://sinhala.sourceforge.net/"
SRC_URI="http://sinhala.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/scim-0.99.8[-gtk3]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc43.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README
}

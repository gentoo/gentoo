# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/renameutils/renameutils-0.11.0.ebuild,v 1.1 2012/02/09 23:50:48 dev-zero Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="Use your favorite text editor to rename files"
HOMEPAGE="http://www.nongnu.org/renameutils/"
SRC_URI="http://savannah.nongnu.org/download/renameutils/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

DEPEND=">=sys-libs/readline-5.0-r2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.0-destdir.patch"
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

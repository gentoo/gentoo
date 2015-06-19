# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/cups-bjnp/cups-bjnp-2.0.ebuild,v 1.1 2014/09/17 15:55:59 mrueg Exp $

EAPI=5

DESCRIPTION="CUPS backend for the canon printers using the proprietary USB over IP BJNP protocol"
HOMEPAGE="http://sourceforge.net/projects/cups-bjnp/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

src_configure() {
	econf --disable-Werror
}

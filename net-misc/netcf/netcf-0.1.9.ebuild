# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netcf/netcf-0.1.9.ebuild,v 1.1 2012/06/28 05:32:21 cardoe Exp $

EAPI=4

DESCRIPTION="netcf is a cross-platform network configuration library"
HOMEPAGE="https://fedorahosted.org/netcf/"
SRC_URI="https://fedorahosted.org/released/netcf/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-admin/augeas-0.5.0
		dev-libs/libnl:1.1
		dev-libs/libxml2
		dev-libs/libxslt
		sys-libs/readline"
RDEPEND="${DEPEND}"

src_configure() {
	# static libs are a waste of time and disk for this
	econf --disable-static
}

src_install() {
	emake DESTDIR="${ED}" install || die "install failed"
	dodoc AUTHORS ChangeLog README NEWS
}

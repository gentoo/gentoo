# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/ETL/ETL-0.04.15.ebuild,v 1.2 2012/06/03 23:03:50 lu_zero Exp $

EAPI=4

inherit autotools

DESCRIPTION="ETL is a multi-platform class and template library"
HOMEPAGE="http://synfig.org"
SRC_URI="mirror://sourceforge/synfig/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4

	eautoreconf
}

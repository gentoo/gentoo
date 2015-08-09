# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools

DESCRIPTION="System performance benchmark"
HOMEPAGE="http://sysbench.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="aio mysql"

DEPEND="mysql? ( virtual/mysql )
	aio? ( dev-libs/libaio )"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix for bug #297590
	sed -e 's/SUBDIRS \= doc sysbench/SUBDIRS \= sysbench/' -i Makefile.am || die "sed of makefile failed"
	eautoreconf
}

src_configure() {
	if ! use aio; then my_econf="--disable-aio"; fi
	econf $(use_with mysql mysql /usr) $my_econf || die "econf failed"
}
src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README
}

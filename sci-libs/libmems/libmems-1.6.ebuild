# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libmems/libmems-1.6.ebuild,v 1.4 2012/11/08 09:11:51 jlec Exp $

EAPI="2"

inherit autotools

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-libs/boost
	sci-libs/libgenome
	sci-libs/libmuscle"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die
}

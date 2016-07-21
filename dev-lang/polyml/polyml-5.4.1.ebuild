# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit base autotools

MY_P=${PN}.${PV}

DESCRIPTION="Poly/ML is a full implementation of Standard ML"
HOMEPAGE="http://www.polyml.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="X elibc_glibc +gmp portable test +threads"

RDEPEND="X? ( x11-libs/motif:0 )
		gmp? ( >=dev-libs/gmp-5 )
		elibc_glibc? ( threads? ( >=sys-libs/glibc-2.13 ) )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=("${FILESDIR}/${PN}-5.4.1-configure.patch"
	"${FILESDIR}/${PN}-5.4.1-asm.patch")

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		$(use_with X x) \
		$(use_with gmp) \
		$(use_with portable) \
		$(use_with threads)
}

src_test() {
	emake tests || die "tests failed"
}

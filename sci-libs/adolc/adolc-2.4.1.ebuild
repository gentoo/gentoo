# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/adolc/adolc-2.4.1.ebuild,v 1.2 2014/01/15 19:44:44 bicatali Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_IN_SOURCE_BUILD=yes
inherit autotools-utils toolchain-funcs

MYPN=ADOL-C

DESCRIPTION="Automatic differentiation system for C/C++"
HOMEPAGE="https://projects.coin-or.org/ADOL-C/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="|| ( EPL-1.0 GPL-2 )"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="sparse static-libs"

RDEPEND="sparse? ( sci-libs/colpack )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-2.4.0-no-colpack.patch )

src_configure() {
	 local myeconfargs=(
		 $(use_enable sparse)
		 $(use_with sparse colpack "${EPREFIX}"/usr)
	 )
	 autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test test
}

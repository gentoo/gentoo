# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/adolc/adolc-2.5.2.ebuild,v 1.1 2014/10/31 08:22:10 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
#AUTOTOOLS_IN_SOURCE_BUILD=yes

inherit autotools-utils toolchain-funcs

MYPN=ADOL-C

DESCRIPTION="Automatic differentiation system for C/C++"
HOMEPAGE="https://projects.coin-or.org/ADOL-C/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="|| ( EPL-1.0 GPL-2 )"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="mpi sparse static-libs"

RDEPEND="
	mpi? ( sys-cluster/ampi:0= )
	sparse? ( sci-libs/colpack:0= )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-no-colpack.patch
	"${FILESDIR}"/${PN}-2.5.0-pkgconfig-no-ldflags.patch
	"${FILESDIR}"/${P}-dash.patch
)

src_configure() {
	 local myeconfargs=(
		 $(use_enable mpi ampi)
		 $(use_enable sparse)
		 $(use_with sparse colpack "${EPREFIX}"/usr)
	 )
	 autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test test
}

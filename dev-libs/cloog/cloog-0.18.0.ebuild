# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="A loop generator for scanning polyhedra"
HOMEPAGE="http://www.bastoul.net/cloog/"
SRC_URI="http://www.bastoul.net/cloog/pages/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

DEPEND="dev-libs/gmp
	<dev-libs/isl-0.13
	!dev-libs/cloog-ppl"
RDEPEND="${DEPEND}"

DOCS=( README )

src_prepare() {
	# m4/ax_create_pkgconfig_info.m4 includes LDFLAGS
	# sed to avoid eautoreconf
	sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die
}

src_configure() {
	econf \
		--with-isl=system \
		--with-polylib=no \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}

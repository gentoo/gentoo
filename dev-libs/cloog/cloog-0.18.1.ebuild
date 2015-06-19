# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cloog/cloog-0.18.1.ebuild,v 1.15 2015/04/13 08:58:39 ago Exp $

EAPI="5"

inherit eutils multilib-minimal

DESCRIPTION="A loop generator for scanning polyhedra"
HOMEPAGE="http://www.bastoul.net/cloog/"
SRC_URI="http://www.bastoul.net/cloog/pages/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/4"
KEYWORDS="alpha amd64 arm arm64 ~hppa ~ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

RDEPEND=">=dev-libs/gmp-5.1.3-r1[${MULTILIB_USEDEP}]
	>=dev-libs/isl-0.12.2:0/10[${MULTILIB_USEDEP}]
	!dev-libs/cloog-ppl"
DEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS=( README )

src_prepare() {
	# m4/ax_create_pkgconfig_info.m4 includes LDFLAGS
	# sed to avoid eautoreconf
	sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--with-gmp=system \
		--with-isl=system \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}

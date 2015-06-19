# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/wcslib/wcslib-4.22.ebuild,v 1.1 2014/05/06 15:55:36 bicatali Exp $

EAPI=5

FORTRAN_NEEDED=fortran

inherit eutils fortran-2 multilib

DESCRIPTION="Astronomical World Coordinate System transformations library"
HOMEPAGE="http://www.atnf.csiro.au/people/mcalabre/WCS/"
SRC_URI="ftp://ftp.atnf.csiro.au/pub/software/${PN}/${P}.tar.bz2"

SLOT="0/4"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fortran fits pgplot static-libs"

RDEPEND="
	fits? ( sci-libs/cfitsio:0= )
	pgplot? ( sci-libs/pgplot:0= )"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's/COPYING\*//' GNUmakefile || die
}

src_configure() {
	local myconf=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable static-libs static)
		$(use_enable fortran)
	)
	# hacks because cfitsio and pgplot directories are hard-coded
	if use fits; then
		myconf+=(
			--with-cfitsioinc="${EPREFIX}/usr/include"
			--with-cfitsiolib="${EPREFIX}/usr/$(get_libdir)"
		)
	else
		myconf+=( --without-cfitsio )
	fi
	if use pgplot; then
		myconf+=(
			--with-pgplotinc="${EPREFIX}/usr/include"
			--with-pgplotlib="${EPREFIX}/usr/$(get_libdir)"
		)
	else
		myconf+=( --without-pgplot )
	fi
	econf ${myconf[@]}
}

src_compile() {
	# nasty makefile, debugging means probably full rewrite
	emake -j1
}

src_test() {
	emake -j1 check
}

src_install () {
	default
	# static libs are same as shared (compiled with PIC)
	# so they are not compiled twice
	use static-libs || rm "${ED}"/usr/$(get_libdir)/lib*.a
	use doc || rm -r \
		"${ED}"/usr/share/doc/${PF}/html \
		"${ED}"/usr/share/doc/${PF}/*.pdf
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran

inherit flag-o-matic fortran-2

DESCRIPTION="Astronomical World Coordinate System transformations library"
HOMEPAGE="https://www.atnf.csiro.au/people/mcalabre/WCS/"
SRC_URI="ftp://ftp.atnf.csiro.au/pub/software/${PN}/${P}.tar.bz2"

SLOT="0/7"
LICENSE="LGPL-3"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc fortran fits pgplot static-libs +tools"

RDEPEND="
	fits? ( sci-libs/cfitsio:0= )
	pgplot? ( sci-libs/pgplot:0= )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/flex-2.6.0
	virtual/pkgconfig"

src_configure() {
	# workaround until upstream fix it properly
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	local myconf=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable fortran)
		$(use_enable tools utils)
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
	econf "${myconf[@]}"
	sed -i -e 's/COPYING\*//' GNUmakefile || die
}

src_install () {
	default
	# static libs share the same symbols as shared (i.e. compiled with PIC)
	# so they are not compiled twice
	use static-libs || rm "${ED}"/usr/$(get_libdir)/lib*.a
	use doc || rm -r \
		"${ED}"/usr/share/doc/${PF}/html \
		"${ED}"/usr/share/doc/${PF}/*.pdf
}

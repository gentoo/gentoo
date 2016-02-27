# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs autotools

DESCRIPTION="FITS library and utlities for astronomical images"
HOMEPAGE="https://github.com/ericmandel/funtools"
SRC_URI="https://github.com/ericmandel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	sys-libs/zlib:0=
	sci-astronomy/wcstools:0=
	sci-visualization/gnuplot"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	# respect libdir, dont build wcs, respect toolchain
	sed -e "/INSTALL/s|/lib|/$(get_libdir)|g" \
		-e 's|${OBJS}|$(OBJS)|g' \
		-e '/^SUBLIBS/s|wcs||g' \
		-e 's/mkdir/mkdir -p/g' \
		-e '/mklib/s|-o $(PACKAGE)|-o $(PACKAGE) $(LIBS)|g' \
		-e "s| ar| $(tc-getAR)|g" \
		-e "s|ar cruv|$(tc-getAR) cruv|g" \
		-e "s|WCS_INC.*=.*|WCS_INC = $($(tc-getPKG_CONFIG) --cflags wcstools)|g" \
		-i Makefile.in */Makefile.in || die
	# fix race condition (when ccache is on)
	sed -e 's|$(LIB):|$(LIB): FORCE|g' \
		-e '$aFORCE:' \
		-i */Makefile.in || die
	eautoreconf
}

src_configure() {
	econf \
		--exec-prefix="${EPREFIX}/usr" \
		--enable-shared \
		--enable-dl \
		--with-wcslib="$($(tc-getPKG_CONFIG) --libs wcstools)" \
		--with-zlib="$($(tc-getPKG_CONFIG) --libs zlib)" \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
}

src_compile() {
	emake
	emake shtclfun
}

src_install () {
	default
	# install missing includes
	insinto /usr/include/funtools/fitsy
	doins fitsy/*.h
	# fix bug #536630
	mv "${ED}"/usr/share/man/man3/funopen.3 \
	   "${ED}"/usr/share/man/man7/funopen.7 \
		|| die
	use doc && cd doc && dodoc *.pdf *html *c
}

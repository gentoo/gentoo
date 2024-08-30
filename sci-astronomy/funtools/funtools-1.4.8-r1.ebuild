# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs autotools

DESCRIPTION="FITS library and utlities for astronomical images"
HOMEPAGE="https://github.com/ericmandel/funtools"
SRC_URI="https://github.com/ericmandel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="
	dev-lang/tcl:0=
	sci-astronomy/wcstools
	sci-visualization/gnuplot
	sys-libs/zlib:0=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	# respect libdir, dont build wcs, respect toolchain
	sed -e "/INSTALL/s|/lib|/$(get_libdir)|g" \
		-e 's|${OBJS}|$(OBJS)|g' \
		-e '/^SUBLIBS/s|wcs||g' \
		-e 's/mkdir/mkdir -p/g' \
		-e '/mklib/s|-o $(PACKAGE)|-o $(PACKAGE) $(LIBS)|g' \
		-e 's|./mklib|& -linker "$(CC)" -ldflags "$(LDFLAGS)"|' \
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
	local myeconfargs=(
		--exec-prefix="${EPREFIX}/usr"
		--enable-shared
		--enable-dl
		--with-wcslib="$($(tc-getPKG_CONFIG) --libs wcstools)"
		--with-zlib="$($(tc-getPKG_CONFIG) --libs zlib)"
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake
	emake shtclfun
}

src_install() {
	default
	# install missing includes
	insinto /usr/include/funtools/fitsy
	doins fitsy/*.h

	# fix bug #536630
	mv "${ED}"/usr/share/man/man3/funopen.3 \
	   "${ED}"/usr/share/man/man7/funopen.7 \
		|| die

	if use doc; then
		dodoc doc/*.pdf doc/*html doc/*c
		docompress -x /usr/share/doc/${PF}/*.c
	fi

	if ! use static-libs; then
		find "${ED}" -name "*.a" -type f -delete || die
	fi
}

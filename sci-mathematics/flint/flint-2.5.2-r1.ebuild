# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/13"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="doc gc ntl static-libs"

BDEPEND="doc? (
	app-text/texlive-core
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
)"
DEPEND="dev-libs/gmp:=
	dev-libs/mpfr:=
	gc? ( dev-libs/boehm-gc )
	ntl? ( dev-libs/ntl:= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/flintxx-include.patch"
	"${FILESDIR}/${PN}-2.5.2-pie.patch"
	"${FILESDIR}/${PN}-2.5.2-utf8.patch"
	"${FILESDIR}/${PN}-2.5.2-memory_message.patch"
)

src_prepare() {
	default

	# The autodetection finds "lib" first, which may e.g. contain 32-bit
	# libs during a 64-bit build.
	sed -e "s:{GMP_DIR}/lib\":{GMP_DIR}/$(get_libdir)\":g" \
		-e "s:{MPFR_DIR}/lib\":{MPFR_DIR}/$(get_libdir)\":g" \
		-e "s:{NTL_DIR}/lib\":{NTL_DIR}/$(get_libdir)\":g" \
		-e "s:{GC_DIR}/lib\":{GC_DIR}/$(get_libdir)\":g" \
		-i configure || die
}

src_configure() {
	./configure \
		--prefix="${EPREFIX}/usr" \
		--with-gmp="${EPREFIX}/usr" \
		--with-mpfr="${EPREFIX}/usr" \
		$(usex ntl "--with-ntl=${EPREFIX}/usr" "") \
		$(use_enable static-libs static) \
		$(usex gc "--with-gc=${EPREFIX}/usr" "") \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		|| die
}

src_compile() {
	emake verbose
	use doc && emake -C doc/latex
}

src_test() {
	emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
	einstalldocs
	use doc && dodoc doc/latex/flint-manual.pdf
}

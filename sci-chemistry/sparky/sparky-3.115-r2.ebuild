# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit flag-o-matic prefix python-single-r1 toolchain-funcs

DESCRIPTION="Graphical NMR assignment and integration program for large polymers"
HOMEPAGE="http://www.cgl.ucsf.edu/home/sparky/"
SRC_URI="http://www.cgl.ucsf.edu/home/sparky/distrib-${PV}/${PN}-source-${PV}.tar.gz"

LICENSE="sparky"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-shells/tcsh
	dev-lang/tcl:0=
	dev-lang/tk:0="
DEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${PV}-wrapper-r1.patch
	"${FILESDIR}"/${PV}-paths.patch
	"${FILESDIR}"/${PV}-makefile.patch
	"${FILESDIR}"/${PV}-fix-c++14.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	TKVER=$(best_version dev-lang/tk | cut -d- -f3 | cut -d. -f1,2)
	PYVER=${EPYTHON#python}
}

src_prepare() {
	default

	sed -i \
		-e "s:^\(set PYTHON =\).*:\1 ${PYTHON}:g" \
		-e "s:^\(setenv SPARKY_INSTALL[[:space:]]*\).*:\1 ${EPREFIX}/usr/$(get_libdir)/${PN}:g" \
		-e "s:tcl8.4:tcl${TKVER}:g" \
		-e "s:tk8.4:tk${TKVER}:g" \
		-e "s:^\(setenv TCLTK_LIB[[:space:]]*\).*:\1 ${EPREFIX}/usr/$(get_libdir):g" \
		"${S}"/bin/sparky || die
	eprefixify "${S}"/bin/sparky
}

src_compile() {
	emake \
		SPARKY="${S}" \
		PYTHON_VERSION="${PYVER}" \
		PYTHON_PREFIX="${EPREFIX}/usr" \
		PYTHON_LIB="${EPREFIX}/usr/$(get_libdir)" \
		PYTHON_INC="$(python_get_includedir)" \
		TK_PREFIX="${EPREFIX}/usr" \
		TCLTK_VERSION="${TKVER}" \
		TKLIBS="-L${EPREFIX}/usr/$(get_libdir)/ -ltk -ltcl -lX11" \
		CXX="$(tc-getCXX)" \
		CC="$(tc-getCC)" \
		LDSHARED="-shared" \
		binaries

	rm c++/*.o || die

	emake \
		SPARKY="${S}" \
		PYTHON_VERSION="${PYVER}" \
		PYTHON_PREFIX="${EPREFIX}/usr" \
		PYTHON_LIB="${EPREFIX}/usr/$(get_libdir)" \
		PYTHON_INC="$(python_get_includedir)" \
		TK_PREFIX="${EPREFIX}/usr" \
		TCLTK_VERSION="${TKVER}" \
		TKLIBS="-L${EPREFIX}/usr/$(get_libdir)/ -ltk -ltcl -lX11" \
		CXX="$(tc-getCXX)" \
		CC="$(tc-getCC)" \
		CXXFLAGS="${CXXFLAGS} -fPIC" \
		CFLAGS="${CFLAGS} -fPIC" \
		LDSHARED="-shared -fPIC" \
		libraries
}

src_install() {
	# The symlinks are needed to avoid hacking the complete code to fix the locations
	dobin c++/{{bruk,matrix,peaks,pipe,vnmr}2ucsf,ucsfdata,sparky-no-python} bin/${PN}

	insinto /usr/share/${PN}/
	doins lib/{print-prolog.ps,Sparky}
	dosym ../../share/${PN}/print-prolog.ps /usr/$(get_libdir)/${PN}/print-prolog.ps
	dosym ../../share/${PN}/Sparky /usr/$(get_libdir)/${PN}/Sparky

	python_moduleinto ${PN}
	python_domodule python/*.py c++/{spy.so,_tkinter.so}
	dosym ../${EPYTHON}/site-packages /usr/$(get_libdir)/${PN}/python

	rm manual/{pkzip.cfg,Makefile} || die
	mv {manual/,}manual.ps || die
	local DOCS=( README manual.ps )
	local HTML_DOCS=( manual/. )
	einstalldocs
	newdoc python/README README.python
	dosym ../../share/doc/${PF}/html /usr/$(get_libdir)/${PN}/manual

	if use examples; then
		dodoc -r example
		dosym ../../share/doc/${PF}/example /usr/$(get_libdir)/${PN}/example
	fi
}

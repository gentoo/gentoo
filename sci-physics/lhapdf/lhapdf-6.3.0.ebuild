# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

MY_PV=$(ver_cut 1-3)
MY_PF=LHAPDF-${MY_PV}

DESCRIPTION="Les Houches Parton Density Function unified library"
HOMEPAGE="http://lhapdf.hepforge.org/"
SRC_URI="http://www.hepforge.org/archive/lhapdf/${MY_PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:0=
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)"

S="${WORKDIR}/${MY_PF}"

src_configure() {
	econf \
		--disable-static \
		$(use_enable python)

	if use python; then
		cd "${S}"/wrappers/python || die
		distutils-r1_src_prepare
	fi
}

src_compile() {
	emake all $(use doc && echo doxy)

	if use python; then
		cd "${S}"/wrappers/python || die
		distutils-r1_src_compile
	fi
}

src_test() {
	emake -C tests
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && dodoc -r doc/doxygen/.
	use examples && doins examples/*.cc

	if use python; then
		cd "${S}"/wrappers/python || die
		distutils-r1_src_install
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "Download data files from:"
	elog "http://www.hepforge.org/archive/${PN}/pdfsets/$(ver_cut 1-2)"
	elog "and untar them into ${EPREFIX}/usr/share/LHAPDF"
}

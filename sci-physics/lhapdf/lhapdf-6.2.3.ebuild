# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AUTOTOOLS_IN_SOURCE_BUILD=yes
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

MY_PV=$(ver_cut 1-3)
MY_PF=LHAPDF-${MY_PV}

DESCRIPTION="Les Houches Parton Density Function unified library"
HOMEPAGE="http://lhapdf.hepforge.org/"
SRC_URI="http://www.hepforge.org/archive/lhapdf/${MY_PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc examples python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:0=
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex] )"

S="${WORKDIR}/${MY_PF}"

src_configure() {
	econf $(use_enable python)
	if use python; then
		cd "${S}/wrappers/python" && distutils-r1_src_prepare
	fi
}

src_compile() {
	emake all $(use doc && echo doxy)
	if use python; then
	   cd "${S}/wrappers/python" && distutils-r1_src_compile
	fi
}

src_test() {
	emake -C tests
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && dodoc -r doc/doxygen/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.cc
	fi
	if use python; then
	   cd "${S}/wrappers/python" && distutils-r1_src_install
	fi
}

pkg_postinst() {
	elog "Download data files from:"
	elog "http://www.hepforge.org/archive/${PN}/pdfsets/$(ver_cut 1-2)"
	elog "and untar them into ${EPREFIX}/usr/share/LHAPDF"
}

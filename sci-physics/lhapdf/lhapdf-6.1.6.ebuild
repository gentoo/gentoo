# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=yes
PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit versionator autotools-utils distutils-r1

MY_PV=$(get_version_component_range 1-3 ${PV})
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
	autotools-utils_src_configure $(use_enable python)
	if use python; then
		cd "${S}/wrappers/python" && distutils-r1_src_prepare
	fi
}

src_compile() {
	autotools-utils_src_compile all $(use doc && echo doxy)
	if use python; then
	   cd "${S}/wrappers/python" && distutils-r1_src_compile
	fi
}

src_test() {
	autotools-utils_src_compile -C tests
}

src_install() {
	autotools-utils_src_install
	use doc && dohtml -r doc/doxygen/*
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
	elog "http://www.hepforge.org/archive/${PN}/pdfsets/$(get_version_component_range 1-2 ${PV})"
	elog "and untar them into ${EROOT%/}/usr/share/LHAPDF"
}

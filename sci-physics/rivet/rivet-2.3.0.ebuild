# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 autotools-utils bash-completion-r1

MYP=Rivet-${PV}

DESCRIPTION="Toolkit for validation of Monte Carlo HEP event generators"
HOMEPAGE="http://rivet.hepforge.org/"

SRC_URI="http://www.hepforge.org/archive/${PN}/${MYP}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc python static-libs"

RDEPEND="
	dev-libs/boost:0=
	sci-libs/gsl:0=
	sci-physics/fastjet:0=[plugins]
	sci-physics/hepmc:0=
	sci-physics/yoda:0=[python]
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex,dot] )
	python? ( dev-python/cython[${PYTHON_USEDEP}] )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MYP}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=(
		$(use_enable python pyext)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && doxygen Doxyfile
}

src_install() {
	autotools-utils_src_install
	newbashcomp "${ED}"/usr/share/Rivet/rivet-completion rivet
	use doc && dohtml -r doxy/html/* && dodoc doc/rivet-manual.pdf
}

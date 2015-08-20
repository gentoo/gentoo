# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 autotools-utils bash-completion-r1

MYP=YODA-${PV}

DESCRIPTION="Yet more Objects for (High Energy Physics) Data Analysis"
HOMEPAGE="http://yoda.hepforge.org/"

SRC_URI="http://www.hepforge.org/archive/${PN}/${MYP}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="c++11 python root static-libs"

RDEPEND="
	dev-libs/boost:0=
	python? ( ${PYTHON_DEPS} )
	root? ( sci-physics/root:0=[python=,${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	python? ( dev-python/cython[${PYTHON_USEDEP}] )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MYP}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=(
		$(use_enable c++11 stdcxx11)
		$(use_enable python pyext)
		$(use_enable root)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	newbashcomp "${ED}"/usr/share/YODA/yoda-completion yoda
}

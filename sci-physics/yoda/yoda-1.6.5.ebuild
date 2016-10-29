# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 bash-completion-r1

MYP=YODA-${PV}

DESCRIPTION="Yet more Objects for (High Energy Physics) Data Analysis"
HOMEPAGE="http://yoda.hepforge.org/"

SRC_URI="http://www.hepforge.org/archive/${PN}/${MYP}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="python root static-libs"

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
	econf \
		$(use_enable python pyext) \
		$(use_enable root) \
		$(use_enable static-libs static)
}

src_install() {
	default
	newbashcomp "${ED%/}"/usr/share/YODA/yoda-completion yoda
}

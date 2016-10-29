# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 python-single-r1

DESCRIPTION="Yet more Objects for (High Energy Physics) Data Analysis"
HOMEPAGE="http://yoda.hepforge.org/"

SRC_URI="http://www.hepforge.org/archive/${PN}/${P^^}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="python root static-libs"

RDEPEND="
	dev-libs/boost:=
	python? ( ${PYTHON_DEPS} )
	root? ( sci-physics/root:=[python=,${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	python? ( dev-python/cython[${PYTHON_USEDEP}] )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${P^^}"

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

	newbashcomp "${ED%/}"/usr/share/YODA/yoda-completion ${PN}
	rm "${ED%/}"/usr/share/YODA/yoda-completion || die
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="PyMOL plugin for convinient movie creation"
SRC_URI="http://www.weizmann.ac.il/ISPC/eMovie_package.zip"
HOMEPAGE="http://www.weizmann.ac.il/ISPC/eMovie.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~x86-linux ~amd64-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>sci-chemistry/pymol-0.99[${PYTHON_USEDEP}]"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-indent.patch
}

src_install(){
	python_moduleinto pmg_tk/startup
	python_foreach_impl python_domodule eMovie.py
	python_foreach_impl python_optimize
}

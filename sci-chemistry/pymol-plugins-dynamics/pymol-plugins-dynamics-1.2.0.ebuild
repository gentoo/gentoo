# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

MY_PN="Dynamics"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Molecular dynamics in Pymol"
HOMEPAGE="https://github.com/tomaszmakarewicz/Dynamics"
SRC_URI="https://github.com/tomaszmakarewicz/Dynamics/archive/v1.2.0.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

DOCS=( manual.odt )

src_prepare() {
	sed \
		-e "/sys.path.insert/d" \
		-e "s:import dynamics_pymol_plugin:from pmg_tk.startup import dynamics_pymol_plugin:g" \
		-i pydynamics* || die
}

src_install() {
	python_moduleinto pmg_tk/startup
	python_parallel_foreach_impl python_domodule dynamics_pymol_plugin.py
	python_parallel_foreach_impl python_doscript pydynamics*
}

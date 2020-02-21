# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Quantum master equation package for Quantum dot transport calculations"
HOMEPAGE="https://github.com/gedaskir/qmeq"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	examples? ( https://github.com/gedaskir/${PN}-examples/archive/${PV}.tar.gz -> ${PN}-examples-${PV}.tgz )
"

KEYWORDS="~amd64"
IUSE="examples"
LICENSE="BSD-2"
SLOT="0"

COMMON_DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
RDEPEND="
	${COMMON_DEPEND}
	examples? ( dev-python/jupyter[${PYTHON_USEDEP}] )
"
DEPEND="
	${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install
	docompress -x "/usr/share/doc/${PF}"
	use examples && dodoc -r "${WORKDIR}/${PN}-examples-${PV}"/*
}

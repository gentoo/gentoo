# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1

Pcommit="d3949bf812e1648892959a169a7ff849cd7b69d5"
MY_PV="$(ver_cut 1-2)"

DESCRIPTION="Quantum master equation package for Quantum dot transport calculations"
HOMEPAGE="https://github.com/gedaskir/qmeq"
SRC_URI="
	https://github.com/gedaskir/qmeq/archive/${Pcommit}.tar.gz -> ${PN}-${PV}.tgz
	examples? ( https://github.com/gedaskir/${PN}-examples/archive/1.0.tar.gz -> ${PN}-examples-1.0.tgz )"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	examples? ( dev-python/jupyter[${PYTHON_USEDEP}] )"
BDEPEND="${DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

src_unpack() {
	default
	mv -v "${PN}-${Pcommit}" "${P}" || die
}

src_install() {
	distutils-r1_src_install
	docompress -x "/usr/share/doc/${PF}"
	use examples && dodoc -r "${WORKDIR}/${PN}-examples-${MY_PV}"/.
}

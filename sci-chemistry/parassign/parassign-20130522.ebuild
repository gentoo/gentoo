# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 python-r1

DESCRIPTION="Assign protein nuclei solely on the basis of pseudocontact shifts (PCS)"
HOMEPAGE="http://protchem.lic.leidenuniv.nl/software/parassign/registration"
SRC_URI="PARAssign_Linux_x64_86.tgz"
RESTRICT="fetch"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scientificpython[${PYTHON_USEDEP}]
	sci-biology/biopython[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

S="${WORKDIR}"/PARAssign_Linux_x64_86/

src_prepare() {
	sed \
		-e '1i#!/usr/bin/python2' \
		-i code/*py || die

	if use x86; then
		sed \
			-e "s:munkres64:munkres:g" \
			-i modules/setup.py || die
	elif use amd64; then
		sed \
			-e "s:munkres:munkres64:g" \
			-i code/*py || die
	fi
	cd modules || die
	rm *o *c || die
	distutils-r1_src_prepare
}

src_compile() {
	cd modules || die
	distutils-r1_src_compile
}

src_install() {
	python_parallel_foreach_impl python_doscript code/* || die

	dodoc PARAssign_Tutorial.pdf README

	cd modules || die
	distutils-r1_src_install
}

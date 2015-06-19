# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/atom/atom-0.3.10.ebuild,v 1.3 2015/03/08 23:39:47 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Memory efficient Python objects"
HOMEPAGE="https://github.com/nucleic/atom"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="Clear-BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		app-arch/unzip
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Required to avoid file collisions at install
	sed -e "s:find_packages():find_packages(exclude=['tests']):" -i setup.py || die

	# Reset from use of local paths
	if use test; then
		sed -e 's:from .catom:from catom:g' -i ${PN}/*.py || die
	fi

	append-flags -fno-strict-aliasing

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${BUILD_DIR}"/lib:"${BUILD_DIR}"/lib/${PN} \
		nosetests || die "Tests failed"
	pushd "${BUILD_DIR}"/lib > /dev/null
	# Change the state back to original ready for installing
	sed -e 's:from catom:from .catom:g' -i ${PN}/*.py
	popd > /dev/null
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

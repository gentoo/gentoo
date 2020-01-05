# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Asset management for Python web development"
HOMEPAGE="https://github.com/miracle2k/webassets"
SRC_URI="https://github.com/miracle2k/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
# ^^ pypi tarball is missing tests
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# webassets wants /usr/bin/babel from babeljs,
	# but we have only one from openbabel
	# ... and we don't have postcss
	sed -i \
		-e 's|\(TestBabel\)|No\1|' \
		-e 's|\(TestAutoprefixer6Filter\)|No\1|' \
		tests/test_filters.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die
}

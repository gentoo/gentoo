# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Fork of pathlib aiming to support the full stdlib Python API"
HOMEPAGE="https://github.com/mcmtroffaes/pathlib2"
SRC_URI="mirror://pypi/p/pathlib2/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/scandir[${PYTHON_USEDEP}]' -2 )
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' -2) )"

python_prepare_all() {
	# stop using private Python API
	# https://github.com/mcmtroffaes/pathlib2/issues/39
	sed -i -e 's/support\.android_not_root/False/' test*.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" test_pathlib2.py -v || die
	"${EPYTHON}" test_pathlib2_with_py2_unicode_literals.py -v || die
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7,8}} )

inherit distutils-r1

DESCRIPTION="Python bindings for the Enchant spellchecking system"
HOMEPAGE="http://pyenchant.sourceforge.net https://pypi.org/project/pyenchant/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-text/enchant"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		app-dicts/myspell-en
	)"

python_prepare_all() {
	# Avoid a test failure when there is no dictionary
	# matching the available locales
	# https://github.com/rfk/pyenchant/issues/134
	sed -i 's/test_default_language/_&/' enchant/checker/tests.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

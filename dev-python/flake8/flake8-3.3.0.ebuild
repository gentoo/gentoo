# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://bitbucket.org/tarek/flake8 https://pypi.python.org/pypi/flake8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
IUSE="test"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
LICENSE="MIT"
SLOT="0"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python2*' 'pypy*' )
	>=dev-python/pyflakes-1.5.0[${PYTHON_USEDEP}]
	<dev-python/pyflakes-1.6.0[${PYTHON_USEDEP}]
	!~dev-python/pyflakes-1.2.0
	!~dev-python/pyflakes-1.2.1
	!~dev-python/pyflakes-1.2.2
	>=dev-python/pycodestyle-2.0.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.4.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/configparser[${PYTHON_USEDEP}]' 'python2*' pypy )
	"
PDEPEND="
	>=dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${PDEPEND}
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		|| (
			>dev-python/pytest-3.0.5[${PYTHON_USEDEP}]
			<dev-python/pytest-3.0.5[${PYTHON_USEDEP}]
		)
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Gentoo has flake8 support restored in >=pep8-1.6.2-r1.
	sed -i -e 's:, != 1.6.2::' setup.py || die
	# Flake8 falsely assumes it needs pytest-runner unconditionally and will
	# try to install it, causing sandbox violations.
	sed -i -e "/setup_requires=\['pytest-runner'\],/d" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	pytest || die "tests failed"
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="IRC client framework written in Python"
HOMEPAGE="https://github.com/jaraco/irc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/importlib_metadata[${PYTHON_USEDEP}]' python3_{6,7})
	dev-python/jaraco-collections[${PYTHON_USEDEP}]
	>=dev-python/jaraco-functools-1.20[${PYTHON_USEDEP}]
	>=dev-python/jaraco-itertools-1.8[${PYTHON_USEDEP}]
	dev-python/jaraco-logging[${PYTHON_USEDEP}]
	dev-python/jaraco-stream[${PYTHON_USEDEP}]
	dev-python/jaraco-text[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/tempora-1.6[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/backports-unittest-mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs '>=dev-python/jaraco-packaging-3.2' \
	'>=dev-python/rst-linker-1.9'

python_test() {
	# Override pytest options to skip flake8
	# Skip a test that fails with 3.8 until it is fixed
	# https://github.com/jaraco/irc/issues/165
	pytest -vv --override-ini="addopts=--doctest-modules" \
		--deselect irc/tests/test_client_aio.py::test_privmsg_sends_msg \
		|| die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/scripts"
		dodoc -r scripts
	fi
	distutils-r1_python_install_all
}

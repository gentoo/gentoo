# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 multiprocessing

DESCRIPTION="HTTP client/server for asyncio"
HOMEPAGE="
	https://github.com/aio-libs/aiohttp/
	https://pypi.org/project/aiohttp/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test-rust"

RDEPEND="
	app-arch/brotli[python,${PYTHON_USEDEP}]
	>=dev-python/aiosignal-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/async-timeout-4.0.0_alpha3[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.3.0[${PYTHON_USEDEP}]
	>=dev-python/charset_normalizer-2.0[${PYTHON_USEDEP}]
	>=dev-python/frozenlist-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/multidict-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/yarl-1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		app-arch/brotli[python,${PYTHON_USEDEP}]
		dev-python/async_generator[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
		test-rust? (
			dev-python/trustme[${PYTHON_USEDEP}]
		)
	)
"

DOCS=( CHANGES.rst CONTRIBUTORS.txt README.rst )

distutils_enable_tests pytest

src_prepare() {
	# increase the timeout a little
	sed -e '/abs_tol=/s/0.001/0.01/' -i tests/test_helpers.py || die

	# xfail_strict fails on py3.10
	sed -i -e '/--cov/d' -e '/xfail_strict/d' setup.cfg || die

	# which(1)...
	sed -i -e 's:which:command -v:' Makefile || die

	# remove upper bound from charset-normalizer
	sed -i -e '/charset-normalizer/s:, < 3\.0::' setup.cfg || die

	distutils-r1_src_prepare
}

python_configure_all() {
	# workaround missing files
	mkdir requirements tools || die
	> requirements/cython.txt || die
	> tools/gen.py || die
	chmod +x tools/gen.py || die
	# force rehashing first
	emake requirements/.hash/cython.txt.hash
	> .update-pip || die
	> .install-cython || die
	emake cythonize
}

python_test() {
	local EPYTEST_IGNORE=(
		# proxy is not packaged
		tests/test_proxy_functional.py
	)

	local EPYTEST_DESELECT=(
		# Internet
		tests/test_client_session.py::test_client_session_timeout_zero
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# C extensions are not used on PyPy3
				tests/test_http_parser.py::test_c_parser_loaded
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_mock,xdist.plugin,pytest_forked
	rm -rf aiohttp || die
	epytest -n "$(makeopts_jobs)" --forked
}

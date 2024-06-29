# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Compatibility layer for multiple asynchronous event loop implementations"
HOMEPAGE="
	https://github.com/agronholm/anyio/
	https://pypi.org/project/anyio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/idna-2.8[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/exceptiongroup-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.1[${PYTHON_USEDEP}]
	' 3.10)
"
# On amd64, let's get more test coverage by dragging in uvloop, but let's
# not bother on other arches where uvloop may not be supported.
BDEPEND="
	>=dev-python/setuptools-scm-6.4[${PYTHON_USEDEP}]
	test? (
		>=dev-python/exceptiongroup-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/trio-0.23[${PYTHON_USEDEP}]
		' 3.{10..13})
		amd64? (
			$(python_gen_cond_dep '
				>=dev-python/uvloop-0.17[${PYTHON_USEDEP}]
			' python3_{10..12})
		)
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	'>=dev-python/sphinx-rtd-theme-1.2.2' \
	dev-python/sphinxcontrib-jquery \
	dev-python/sphinx-autodoc-typehints

PATCHES=(
	# https://github.com/agronholm/anyio/pull/740
	"${FILESDIR}/${P}-py313.patch"
)

python_test() {
	local EPYTEST_DESELECT=(
		# requires link-local IPv6 interface
		tests/test_sockets.py::TestTCPListener::test_bind_link_local
	)

	local filter=()
	if ! has_version ">=dev-python/trio-0.23[${PYTHON_USEDEP}]"; then
		filter+=( -k "not trio" )
		EPYTEST_DESELECT+=(
			tests/test_pytest_plugin.py::test_plugin
			tests/test_pytest_plugin.py::test_autouse_async_fixture
			tests/test_pytest_plugin.py::test_cancel_scope_in_asyncgen_fixture
		)
	fi

	case ${EPYTHON} in
		python3.13)
			EPYTEST_DESELECT+=(
				'tests/test_fileio.py::TestPath::test_properties[asyncio]'
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m 'not network' "${filter[@]}"
}

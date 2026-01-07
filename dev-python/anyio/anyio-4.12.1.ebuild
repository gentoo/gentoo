# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/agronholm/anyio
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Compatibility layer for multiple asynchronous event loop implementations"
HOMEPAGE="
	https://github.com/agronholm/anyio/
	https://pypi.org/project/anyio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/idna-2.8[${PYTHON_USEDEP}]
	>=dev-python/truststore-0.9.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.5[${PYTHON_USEDEP}]
	' 3.{11..12})
"
# On amd64, let's get more test coverage by dragging in uvloop, but let's
# not bother on other arches where uvloop may not be supported.
BDEPEND="
	>=dev-python/setuptools-scm-6.4[${PYTHON_USEDEP}]
	test? (
		>=dev-python/blockbuster-1.5.23[${PYTHON_USEDEP}]
		>=dev-python/exceptiongroup-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9[${PYTHON_USEDEP}]
		>=dev-python/trustme-1.0.0[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/trio-0.32.0[${PYTHON_USEDEP}]
		' 3.{11..14})
		amd64? (
			$(python_gen_cond_dep '
				>=dev-python/uvloop-0.22.1[${PYTHON_USEDEP}]
			' python3_{11..14})
		)
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-mock )
distutils_enable_tests pytest
distutils_enable_sphinx docs \
	'>=dev-python/sphinx-rtd-theme-1.2.2' \
	dev-python/sphinxcontrib-jquery \
	dev-python/sphinx-autodoc-typehints \
	dev-python/sphinx-tabs

python_test() {
	local EPYTEST_DESELECT=(
		# requires link-local IPv6 interface
		tests/test_sockets.py::TestTCPListener::test_bind_link_local
	)

	local filter=()
	if ! has_version ">=dev-python/trio-0.26.1[${PYTHON_USEDEP}]"; then
		filter+=( -k "not trio" )
		EPYTEST_DESELECT+=(
			tests/test_pytest_plugin.py::test_plugin
			tests/test_pytest_plugin.py::test_autouse_async_fixture
			tests/test_pytest_plugin.py::test_cancel_scope_in_asyncgen_fixture
		)
	fi

	epytest -m 'not network' "${filter[@]}"
}

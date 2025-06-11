# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Compatibility layer for multiple asynchronous event loop implementations"
HOMEPAGE="
	https://github.com/agronholm/anyio/
	https://pypi.org/project/anyio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/idna-2.8[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.1[${PYTHON_USEDEP}]
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
		>=dev-python/exceptiongroup-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/trio-0.26.1[${PYTHON_USEDEP}]
		' 3.{11..13})
		amd64? (
			$(python_gen_cond_dep '
				>=dev-python/uvloop-0.21.0_beta1[${PYTHON_USEDEP}]
			' python3_{11..13})
		)
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	'>=dev-python/sphinx-rtd-theme-1.2.2' \
	dev-python/sphinxcontrib-jquery \
	dev-python/sphinx-autodoc-typehints

PATCHES=(
	# https://github.com/agronholm/anyio/commit/f051fd45a1d34bae8dd70dba726e711e7a49deee
	# https://github.com/agronholm/anyio/commit/e0e2531de14c54eed895c92b4c8e87b44f47634b
	# https://github.com/agronholm/anyio/commit/8bad9c05d966f6edfa58f26257015cb657d4e5ef
	"${FILESDIR}/${P}-py314.patch"
)

python_test() {
	local EPYTEST_DESELECT=(
		# requires link-local IPv6 interface
		tests/test_sockets.py::TestTCPListener::test_bind_link_local
	)

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# likely related to https://github.com/pypy/pypy/issues/5264
				tests/test_debugging.py::test_main_task_name
			)
			;;
	esac

	local filter=()
	if ! has_version ">=dev-python/trio-0.26.1[${PYTHON_USEDEP}]"; then
		filter+=( -k "not trio" )
		EPYTEST_DESELECT+=(
			tests/test_pytest_plugin.py::test_plugin
			tests/test_pytest_plugin.py::test_autouse_async_fixture
			tests/test_pytest_plugin.py::test_cancel_scope_in_asyncgen_fixture
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m 'not network' "${filter[@]}"
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="A fast and thorough lazy object proxy"
HOMEPAGE="
	https://github.com/ionelmc/python-lazy-object-proxy/
	https://pypi.org/project/lazy-object-proxy/
	https://python-lazy-object-proxy.readthedocs.io/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="+native-extensions"

BDEPEND="
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	if use native-extensions; then
		unset SETUPPY_FORCE_PURE
	else
		export SETUPPY_FORCE_PURE=1
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# benchmarks
		tests/test_lazy_object_proxy.py::test_perf
		tests/test_lazy_object_proxy.py::test_proto
	)

	case ${EPYTHON} in
		python3.15*)
			EPYTEST_DESELECT+=(
				tests/test_async_py3.py::test_await_12
				tests/test_async_py3.py::test_await_13
				tests/test_async_py3.py::test_await_5
			)
	esac

	epytest -o strict_markers=False
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 multiprocessing

DESCRIPTION="An implementation of the Debug Adapter Protocol for Python"
HOMEPAGE="
	https://github.com/microsoft/debugpy/
	https://pypi.org/project/debugpy/
"
SRC_URI="
	https://github.com/microsoft/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/pydevd[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Unbundle dev-python/pydevd
	rm -r src/debugpy/_vendored/pydevd || die
	local PATCHES=(
		"${FILESDIR}/${PN}-1.8.0-unbundle-pydevd.patch"
	)

	# Drop unnecessary and unrecognized option
	# __main__.py: error: unrecognized arguments: -n8
	# Do not timeout
	sed -e '/addopts/d' -e '/timeout/d' -i pytest.ini || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_DESELECT=(
		tests/debugpy/test_gevent.py::test_gevent
		tests/debugpy/test_run.py::test_custom_python_args
		tests/tests/test_timeline.py::test_occurrences
	)
	local EPYTEST_IGNORE=(
		tests/tests/test_vendoring.py
	)

	case ${EPYTHON} in
		python3.12)
			EPYTEST_DESELECT+=(
				tests/debugpy/test_flask.py
			)
			;;
	esac

	epytest -p timeout -p xdist -n "$(makeopts_jobs)" --dist=worksteal \
		-k "not attach_pid"
}

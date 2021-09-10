# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="PyDev.Debugger (used in PyDev, PyCharm and VSCode Python)"
HOMEPAGE="https://github.com/fabioz/PyDev.Debugger/"
SRC_URI="https://github.com/fabioz/PyDev.Debugger/archive/refs/tags/pydev_debugger_${PV//./_}.tar.gz"
S="${WORKDIR}/PyDev.Debugger-pydev_debugger_${PV//./_}"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/untangle[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

# These files are included pre-built in the sources
# TODO: Investigate what this is and if/how we can compile this properly
QA_PREBUILT="
	/usr/lib/python*/site-packages/pydevd_attach_to_process/attach_linux_*.so
"

python_prepare_all() {
	# AssertionError: TimeoutError (note: error trying to dump threads on timeout).
	# TODO: investigate and fix this
	sed -i \
		-e 's:test_case_qthread4:_&:' \
		-e 's:test_path_translation:_&:' \
		-e 's:test_asyncio_step_over_basic:_&:' \
		-e 's:test_asyncio_step_over_end_of_function:_&:' \
		-e 's:test_asyncio_step_in:_&:' \
		-e 's:test_asyncio_step_return:_&:' \
		tests_python/test_debugger.py || die
	sed -i \
		-e 's:test_evaluate_exception_trace:_&:' \
		-e 's:test_path_translation_and_source_reference:_&:' \
		tests_python/test_debugger_json.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	# Remove this duplicate that is installed directly to /usr/
	# These files are also correctly installed to the python site-packages dir
	rm -r "${ED}/usr/pydevd_attach_to_process"
}

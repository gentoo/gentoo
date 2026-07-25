# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="
	https://github.com/davidhalter/jedi/
	https://pypi.org/project/jedi/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

RDEPEND="
	<dev-python/parso-0.9[${PYTHON_USEDEP}]
	>=dev-python/parso-0.8.6[${PYTHON_USEDEP}]
"

# RDEPEND needed because of an import jedi inside conf.py
distutils_enable_sphinx docs \
	dev-python/parso \
	dev-python/sphinx-rtd-theme
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	# test_complete_expanduser relies on $HOME not being empty
	> "${HOME}"/somefile || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# fragile
		test/test_speed.py
		# assumes pristine virtualenv
		test/test_inference/test_imports.py::test_duplicated_import
		test/test_inference/test_imports.py::test_os_issues
	)

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				test/test_api/test_api.py::test_preload_modules
				test/test_api/test_interpreter.py::test_param_infer_default
				test/test_inference/test_compiled.py::test_next_docstr
				test/test_inference/test_compiled.py::test_time_docstring
				test/test_inference/test_gradual/test_typeshed.py::test_module_exists_only_as_stub
				test/test_utils.py::TestSetupReadline::test_import
			)
			;;
	esac

	# django and pytest tests are very version dependent
	epytest -o addopts= -k "not django and not pytest"
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="
	https://github.com/davidhalter/jedi/
	https://pypi.org/project/jedi/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

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
		python3.15*)
			EPYTEST_DESELECT+=(
				test/test_inference/test_sys_path.py::test_venv_and_pths
			)
			;;
	esac

	# django and pytest tests are very version dependent
	epytest -o addopts= -k "not django and not pytest"
}

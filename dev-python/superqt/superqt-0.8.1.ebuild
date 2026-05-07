# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/pyapp-kit/superqt
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Missing widgets and components for PyQt/PySide"
HOMEPAGE="
	https://github.com/pyapp-kit/superqt/
	https://pypi.org/project/superqt/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/pygments-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/qtpy-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.12.0[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-qt )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_test() {
	local ALL_QT_APIS=()
	local api

	for api in pyqt6 pyside6; do
		has_version "dev-python/qtpy[${api},${PYTHON_USEDEP}]" || continue
		ALL_QT_APIS+=( "${api}" )
	done
	[[ -z ${ALL_QT_APIS[@]} ]] && die "No Qt6 implementation found?!"

	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_IGNORE=(
		# pint and pyconify not packaged
		tests/test_quantity.py
		tests/test_iconify.py
	)
	local EPYTEST_DESELECT=()

	for api in "${ALL_QT_APIS[@]}"; do
		case ${api} in
			pyqt6)
				EPYTEST_DESELECT=(
					# crashing on assertions
					tests/test_color_combo.py::test_q_color_combobox
				)
				;;
		esac

		einfo "Testing with ${api}"
		epytest -o "qt_api=${api}"
	done
}

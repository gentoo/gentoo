# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

DESCRIPTION="PyQt4/PyQt5 compatibility layer"
HOMEPAGE="
	https://github.com/ales-erjavec/anyqt/
	https://pypi.org/project/AnyQt/
"
SRC_URI="
	https://github.com/ales-erjavec/anyqt/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| (
		dev-python/pyside2[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/pyside2[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local -x QT_API
	# plugins may preload Qt modules
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	for QT_API in pyqt5 pyside2; do
		local EPYTEST_IGNORE=()
		[[ ${QT_API} == pyside2 ]] && EPYTEST_IGNORE+=(
			tests/test_qaction_set_menu.py
		)

		einfo "Testing ${QT_API}"
		nonfatal epytest tests ||
			die "Tests failed with ${EPYTHON} / ${QT_API}"
	done
}

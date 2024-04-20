# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="A Python script for summarizing gcov data"
HOMEPAGE="https://github.com/gcovr/gcovr"
SRC_URI="https://github.com/gcovr/gcovr/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

# tests fail on gcc newer than 5.8
#RESTRICT="test"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing

	local -x PATH="${TEST_DIR}/scripts:${PATH}" \
		PYTHONPATH="${TEST_DIR}/lib"

	local deselect=(
		# those tests fail on gcc newer than 5.8
		# https://github.com/gcovr/gcovr/issues/206
		gcovr/tests/test_gcovr.py
	)

	epytest gcovr ${deselect[@]/#/--deselect }
}

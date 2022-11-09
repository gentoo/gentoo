# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 virtualx

DESCRIPTION="An ultra fast cross-platform multiple screenshots module in python using ctypes"
HOMEPAGE="https://github.com/BoboTiG/python-mss"
SRC_URI="https://github.com/BoboTiG/python-mss/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

S="${WORKDIR}/python-${PN}-${PV}"

BDEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	sys-process/lsof
)"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

python_test() {
	virtx pytest -vv
}

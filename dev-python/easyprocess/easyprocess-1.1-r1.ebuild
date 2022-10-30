# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Easy to use Python subprocess interface"
HOMEPAGE="https://github.com/ponty/EasyProcess"
SRC_URI="https://github.com/ponty/EasyProcess/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/EasyProcess-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

BDEPEND="
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		x11-base/xorg-server[xvfb]
	)"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# looks like a problem within imagemagick itself
	tests/test_fast/test_deadlock.py::test_has_imagemagick
	# TODO
	tests/test_fast/test_deadlock.py::test_deadlock_pipe
)

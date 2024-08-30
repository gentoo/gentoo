# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

MY_P=python-evdev-${PV}
DESCRIPTION="Python library for evdev bindings"
HOMEPAGE="
	https://python-evdev.readthedocs.io/
	https://github.com/gvalkov/python-evdev/
	https://pypi.org/project/evdev/
"
SRC_URI="
	https://github.com/gvalkov/python-evdev/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/test_uinput.py
)

python_configure_all() {
	esetup.py build_ecodes \
		--evdev-headers \
		"${ESYSROOT}/usr/include/linux/input.h:${ESYSROOT}/usr/include/linux/input-event-codes.h"
}

src_test() {
	cd tests || die
	distutils-r1_src_test
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python library for evdev bindings"
HOMEPAGE="https://python-evdev.readthedocs.io/"
SRC_URI="https://github.com/gvalkov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile build_ecodes \
		--evdev-headers \
		"${SYSROOT}"/usr/include/linux/input.h:"${SYSROOT}"/usr/include/linux/input-event-codes.h
}

python_test() {
	# test_uinput requires write access to /dev/uinput
	pytest -vv --deselect tests/test_uinput.py ||
		die "tests failed for ${EPYTHON}"
}

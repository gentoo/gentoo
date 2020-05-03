# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python library for evdev bindings"
HOMEPAGE="https://python-evdev.readthedocs.org/"
SRC_URI="https://github.com/gvalkov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile build_ecodes \
		--evdev-headers \
		"${SYSROOT}"/usr/include/linux/input.h:"${SYSROOT}"/usr/include/linux/input-event-codes.h
}

python_test() {
	pytest -vv tests/test_ecodes.py || die "ecodes test failed for ${EPYTHON}"
	pytest -vv tests/test_events.py || die "events test failed for ${EPYTHON}"
	pytest -vv tests/test_uinput.py || die "uinput test failed foe ${EPYTHON}"
}

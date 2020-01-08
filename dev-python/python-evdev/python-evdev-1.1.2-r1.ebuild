# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="Python library for evdev bindings"
HOMEPAGE="https://python-evdev.readthedocs.org/"
SRC_URI="https://github.com/gvalkov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile() {
	distutils-r1_python_compile build_ecodes \
		--evdev-headers \
		"${SYSROOT}"/usr/include/linux/input.h:"${SYSROOT}"/usr/include/linux/input-event-codes.h
}

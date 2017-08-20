# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Python library for evdev bindings"
HOMEPAGE="https://python-evdev.readthedocs.org/"
SRC_URI="https://github.com/gvalkov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

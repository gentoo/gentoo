# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"
inherit distutils-r1 xdg

MY_PN="${PN^}"
MY_PV=$(ver_rs 2 '-')

DESCRIPTION="Small and highly customizable twin-panel file manager with plugin-support"
HOMEPAGE="https://github.com/MeanEYE/Sunflower
	https://sunflower-fm.org/"
SRC_URI="https://github.com/MeanEYE/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	x11-libs/vte
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}
	dev-python/pycairo[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_PN}-$MY_PV

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1 xdg

DESCRIPTION="Small and highly customizable twin-panel file manager with plugin-support"
HOMEPAGE="https://github.com/MeanEYE/Sunflower
	https://sunflower-fm.org/"
SRC_URI="https://dev.gentoo.org/~slashbeast/distfiles/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}
	dev-python/pycairo[${PYTHON_USEDEP}]
"

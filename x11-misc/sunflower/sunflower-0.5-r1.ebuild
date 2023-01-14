# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
PYTHON_REQ_USE="sqlite"
inherit distutils-r1 xdg

MY_PN="Sunflower"
MY_PV="${PV}-63"

DESCRIPTION="Small and highly customizable twin-panel file manager with plugin-support"
HOMEPAGE="https://github.com/MeanEYE/Sunflower
	https://sunflower-fm.org/"
SRC_URI="https://github.com/MeanEYE/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz"

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
	x11-libs/vte
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_prepare() {
	default

	# Upstream's get_version requires a lot of BDEPENDS we do not want.
	sed 's%version=get_version()%version="0.5"%g' -i setup.py
}

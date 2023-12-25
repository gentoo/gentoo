# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
MY_PN="python-${PN}"
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Raspberry Pi Sense HAT python library"
HOMEPAGE="https://github.com/astro-pi/python-sense-hat"
SRC_URI="https://github.com/astro-pi/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="arm arm64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/rtimulib[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

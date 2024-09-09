# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Preparing acquisition files for processing with the SiriL software"
HOMEPAGE="https://gitlab.com/free-astro/sirilic"
SRC_URI="https://gitlab.com/free-astro/sirilic/-/archive/V${PV}/${PN}-V${PV}.tar.bz2"
S="${WORKDIR}/${PN}-V${PV}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/wxpython-4.2:4.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

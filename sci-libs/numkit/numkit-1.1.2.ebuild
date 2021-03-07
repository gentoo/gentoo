# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Numerical first aid kit (with numpy/scipy)"
HOMEPAGE="https://numkit.readthedocs.io"
S="${WORKDIR}/${PN}-release-${PV}"
SRC_URI="https://github.com/Becksteinlab/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.9[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

MY_PN="${PN/_/-}"
DESCRIPTION="Collection of Python scripts for extracting data from UBI and UBIFS images"
HOMEPAGE="https://github.com/jrspruitt/ubi_reader"
SRC_URI="https://github.com/jrspruitt/ubi_reader/archive/refs/tags/v${PV}-master.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}-master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/python-lzo[${PYTHON_USEDEP}]"

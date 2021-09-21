# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="${PN/_/-}"
DESCRIPTION="Collection of Python scripts for extracting data from UBI and UBIFS images"
HOMEPAGE="https://github.com/jrspruitt/ubi_reader"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/python-lzo[${PYTHON_USEDEP}]"

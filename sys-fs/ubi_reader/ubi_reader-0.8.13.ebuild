# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Collection of Python scripts for extracting data from UBI and UBIFS images"
HOMEPAGE="https://github.com/onekey-sec/ubi_reader"
SRC_URI="https://github.com/onekey-sec/ubi_reader/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/cryptography-44.0.2[${PYTHON_USEDEP}]
	dev-python/lzallright[${PYTHON_USEDEP}]
"

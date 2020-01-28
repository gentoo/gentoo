# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="generates graphs from blktrace to help visualize IO patterns and performance"
HOMEPAGE="https://github.com/trofi/seekwatcher"
SRC_URI="https://github.com/trofi/seekwatcher/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/cython"
RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sys-block/blktrace
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

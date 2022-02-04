# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Nginx configuration static analyzer"
HOMEPAGE="https://github.com/yandex/gixy"
# Use GitHub source insted PyPi to get tarball with tests
SRC_URI="https://github.com/yandex/gixy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/pyparsing-1.5.5[${PYTHON_USEDEP}]
	>=dev-python/configargparse-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.1.0[${PYTHON_USEDEP}]"

distutils_enable_tests nose

PATCHES=(
	"${FILESDIR}"/${P}-backports.patch
)

# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )
inherit distutils-r1

DESCRIPTION="Brain-dead simple config-ini parsing"
HOMEPAGE="
	https://github.com/RonnyPfannschmidt/iniconfig
	"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~sparc ~x86"

BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-pytest-5.patch
)

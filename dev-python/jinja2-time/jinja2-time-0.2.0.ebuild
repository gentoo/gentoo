# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Jinja2 Extension for Dates and Times"
HOMEPAGE="https://github.com/hackebrot/jinja2-time"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/freezegun[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-arrow-compat.patch
)

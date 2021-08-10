# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library (fork of cssutils)"
HOMEPAGE="https://pypi.org/project/css-parser/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/chardet[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.10-test.patch"
)

distutils_enable_tests setup.py

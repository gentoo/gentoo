# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Copy your docs directly to the gh-pages branch"
HOMEPAGE="https://github.com/c-w/ghp-import"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
"

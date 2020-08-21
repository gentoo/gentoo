# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Preview GitHub Markdown files like Readme locally before committing them"
HOMEPAGE="https://github.com/joeyespo/grip"
LICENSE="MIT"

SLOT="0"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="amd64"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!media-sound/grip
	>=dev-python/docopt-0.4.0
	>=dev-python/flask-0.10.1
	>=dev-python/markdown-2.5.1
	>=dev-python/path-and-address-2.0.1
	>=dev-python/pygments-1.6
	>=dev-python/requests-2.4.1
"

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Best attempt to create slugs from unicode strings while keeping it DRY."
HOMEPAGE="https://github.com/un33k/python-slugify"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/text-unidecode"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

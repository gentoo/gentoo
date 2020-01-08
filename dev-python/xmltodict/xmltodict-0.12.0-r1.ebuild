# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3  )

inherit distutils-r1

DESCRIPTION="Makes working with XML feel like you are working with JSON"
HOMEPAGE="https://github.com/martinblech/xmltodict/ https://pypi.org/project/xmltodict/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests nose

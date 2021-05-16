# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Merge a series of JSON documents"
HOMEPAGE="https://github.com/avian2/jsonmerge/ https://pypi.org/project/jsonmerge/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/jsonschema[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

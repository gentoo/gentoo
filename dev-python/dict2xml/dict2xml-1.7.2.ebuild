# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Small utility to convert a python dictionary into an XML string"
HOMEPAGE="https://pypi.org/project/dict2xml/ https://github.com/delfick/python-dict2xml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# dict2xml uses noseOfYeti for its test, which is not yet available.
RESTRICT="test"

distutils_enable_tests pytest

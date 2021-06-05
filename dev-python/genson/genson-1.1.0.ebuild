# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="GenSON is a powerful, user-friendly JSON Schema generator built in Python"
HOMEPAGE="https://pypi.org/project/genson/ https://github.com/wolverdude/GenSON/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( dev-python/jsonschema[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

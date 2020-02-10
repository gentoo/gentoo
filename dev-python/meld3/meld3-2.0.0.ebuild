# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy3 python3_{6,7,8} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="meld3 is an HTML/XML templating engine"
HOMEPAGE="https://github.com/supervisor/meld3 https://pypi.org/project/meld3/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests unittest

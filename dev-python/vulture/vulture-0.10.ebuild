# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="find unused classes, functions and variables in your code"
HOMEPAGE="https://bitbucket.org/jendrikseipp/vulture https://pypi.org/project/vulture/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS=( README.txt NEWS.txt )

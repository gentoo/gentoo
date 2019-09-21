# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="LHA archive support for Python"
HOMEPAGE="https://fengestad.no/python-lhafile/"
SRC_URI="https://fengestad.no/python-lhafile/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# NOTE: The tests don't work, they're probably outdated.

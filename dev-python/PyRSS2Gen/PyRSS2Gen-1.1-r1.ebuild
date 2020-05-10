# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="RSS feed generator written in Python"
HOMEPAGE="http://www.dalkescientific.com/Python/PyRSS2Gen.html https://pypi.org/project/PyRSS2Gen/"
SRC_URI="http://www.dalkescientific.com/Python/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

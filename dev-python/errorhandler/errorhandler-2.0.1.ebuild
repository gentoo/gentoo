# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Logging framework handler"
HOMEPAGE="https://pypi.org/project/errorhandler/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

RDEPEND=""
DEPEND="
	dev-python/pkginfo[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests nose

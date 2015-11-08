# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Adds support for tests durring installation of setup.py files"
HOMEPAGE="https://pypi.python.org/pypi/pytest-runner"
SRC_URI="mirror://pypi/p/${PN}/${P}.zip"

LICENSE="MIT"
KEYWORDS="amd64 ~arm ppc ppc64 sparc x86"
SLOT="0"
IUSE=""

DEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-hgtools.patch
)

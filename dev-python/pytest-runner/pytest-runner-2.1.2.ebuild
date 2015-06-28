# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytest-runner/pytest-runner-2.1.2.ebuild,v 1.4 2015/06/28 12:54:36 maekke Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Adds support for tests durring installation of setup.py files"
HOMEPAGE="http://pypi.python.org/pypi/pytest-runner"
SRC_URI="mirror://pypi/p/${PN}/${P}.zip"

LICENSE="MIT"
KEYWORDS="amd64 ~arm x86"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-hgtools.patch
)

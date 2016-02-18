# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

RESTRICT="test"

inherit distutils-r1 eutils

DESCRIPTION="Classes and setuptools plugin for Mercurial repositories"
HOMEPAGE="https://bitbucket.org/jaraco/hgtools/"
SRC_URI="mirror://pypi/h/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="dev-vcs/mercurial"

DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	pushd "${BUILD_DIR}"/../ > /dev/null
	py.test "${PN}"/tests || die
	popd > /dev/null
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="This package provides cross-platform cross-python shutil.which functionality"
HOMEPAGE="https://github.com/pydanny/whichcraft"
SRC_URI="https://github.com/pydanny/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS=( README.rst HISTORY.rst CONTRIBUTING.rst )

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	${PYTHON} test_whichcraft.py || die
}

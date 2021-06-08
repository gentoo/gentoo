# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="https://pypi.org/project/iniparse/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""

RDEPEND=">=dev-python/six-1.10.0[${PYTHON_USEDEP}]"
BDEPEND=${RDEPEND}

python_test() {
	"${EPYTHON}" runtests.py || die
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Pure Python PNG image encoder/decoder"
HOMEPAGE="https://github.com/drj11/pypng https://pypi.org/project/pypng/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 x86"

python_test() {
	"${EPYTHON}" code/test_png.py -v || die "Tests fail with ${EPYTHON}"
}

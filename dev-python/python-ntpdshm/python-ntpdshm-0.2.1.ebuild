# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{5,6}} pypy )

inherit distutils-r1

DESCRIPTION="Python interface to ntpd shared memory driver 28"
HOMEPAGE="https://github.com/mjuenema/python-ntpdshm"
SRC_URI="${HOMEPAGE}/archive/0.2.1.tar.gz -> ${P}.tar.gz"
# Warning: pypi tarball is not the same
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-lang/swig:0"

src_prepare() {
	emake swig || die
	distutils-r1_src_prepare
}

# tests may break running ntpd!
RESTRICT="test"

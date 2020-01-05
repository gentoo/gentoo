# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python wrapping of the Cap'n Proto library"
HOMEPAGE="http://jparyani.github.io/pycapnp/ https://github.com/capnproto/pycapnp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-libs/capnproto-0.6:="
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
"
PATCHES=( "${FILESDIR}/sdist.patch" )

src_prepare() {
	distutils-r1_src_prepare
	# regen cython files
	rm -f capnp/lib/capnp.cpp || die

	# Need c++14 for capnp 0.7
	sed -e 's/std=c++11/std=c++14/g' \
		-i setup.py \
		-i buildutils/detect.py \
		-i capnp/*/* \
		|| die
}

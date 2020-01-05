# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

MY_PN="${PN}2"

DESCRIPTION="Python implementation of the Sane API and abstration layer"
HOMEPAGE="https://github.com/openpaperwork/pyinsane"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="media-gfx/sane-backends
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RESTRICT="test" # Tests require at least one scanner with a flatbed and an ADF

S=${WORKDIR}/${MY_PN}-${PV}

python_prepare_all() {
	sed -e "/'nose>=1.0'/d" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

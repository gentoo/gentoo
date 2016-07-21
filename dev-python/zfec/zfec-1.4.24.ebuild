# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Fast erasure codec which can be used with the command-line, C, Python, or Haskell"
HOMEPAGE="https://pypi.python.org/pypi/zfec"
SRC_URI="mirror://pypi/z/zfec/zfec-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND=""
RDEPEND="${COMMON_DEPEND}
	dev-python/pyutil[${PYTHON_USEDEP}]
	dev-python/zbase32[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install

	rm -rf "${ED%/}"/usr/share/doc/${PN}
}

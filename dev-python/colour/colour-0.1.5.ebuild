# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python color representations manipulation library"
HOMEPAGE="https://github.com/vaab/colour/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3+"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-setup.patch )

src_prepare() {
	rm setup.cfg || die

	distutils-r1_src_prepare
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python color representations manipulation library"
HOMEPAGE="https://github.com/vaab/colour/"
KEYWORDS="amd64 ~x86"

LICENSE="GPL-3+"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-setup.patch )

src_prepare() {
	rm setup.cfg || die

	distutils-r1_src_prepare
}

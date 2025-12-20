# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Examines C/C++ source code for security flaws"
HOMEPAGE="https://www.dwheeler.com/flawfinder/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~mips ppc ~sparc x86"

PATCHES=( "${FILESDIR}"/${PN}-2.0.18-setup.patch )

src_prepare() {
	sed -e "s/${PN}.1.gz/${PN}.1/g" -i setup.py || die 'sed failed'
	default
}

python_test() {
	emake test
}

python_install_all() {
	local DOCS=( announcement ChangeLog README.md ${PN}.pdf )
	distutils-r1_python_install_all
}

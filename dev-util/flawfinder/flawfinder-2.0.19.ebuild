# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Examines C/C++ source code for security flaws"
HOMEPAGE="https://www.dwheeler.com/flawfinder/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

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

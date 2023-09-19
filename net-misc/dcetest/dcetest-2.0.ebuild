# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="dcetest is a clone of the Windows rpcinfo"
HOMEPAGE="http://www.atstake.com/research/tools/info_gathering/"
SRC_URI="mirror://gentoo/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"

S="${WORKDIR}/${PN}"
PATCHES=( "${FILESDIR}"/${PN}-2.0-fix-build-system.patch )

src_configure() {
	tc-export CC
	append-cflags -funsigned-char -Wall
}

src_install() {
	dobin dcetest
	dodoc CHANGELOG README VERSION nt4sp6adefault.txt out out.txt out2.txt w2ksp0.txt
}

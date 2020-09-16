# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Seagate Fibre-Channel disk firmware upgrade tool"
HOMEPAGE="http://www.tc.umn.edu/~erick205/Projects/"
SRC_URI="http://www.tc.umn.edu/~erick205/Projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	use debug && append-cppflags -DDEBUG
	tc-export CXX
}

src_install() {
	dosbin fwdl
	einstalldocs
}

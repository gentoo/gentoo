# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Parchive archive fixing tool"
HOMEPAGE="http://parchive.sourceforge.net/"
SRC_URI="mirror://sourceforge/parchive/par-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="
	!app-text/par
	!dev-util/par"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/par-cmdline
PATCHES=( "${FILESDIR}"/${PN}-1.1-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin par
	einstalldocs
}

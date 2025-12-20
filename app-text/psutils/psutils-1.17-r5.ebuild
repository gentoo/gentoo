# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="PostScript Utilities"
HOMEPAGE="http://web.archive.org/web/20110722005140/http://www.tardis.ed.ac.uk/~ajcd/psutils/"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.dfsg.orig.tar.gz"
S="${WORKDIR}/${P}.orig"

LICENSE="psutils"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-no-fixmacps.patch
	"${FILESDIR}"/${P}-clang-implicit-int.patch
)

src_compile() {
	emake -f Makefile.unix CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/{bin,share/man}
	emake -f Makefile.unix DESTDIR="${D}" install
	dodoc README
}

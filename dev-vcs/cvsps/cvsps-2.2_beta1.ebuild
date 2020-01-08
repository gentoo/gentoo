# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils toolchain-funcs

MY_P="${P/_beta/b}"
DESCRIPTION="Generates patchset information from a CVS repository"
HOMEPAGE="http://www.catb.org/~esr/cvsps/"
SRC_URI="http://www.cobite.com/cvsps/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1-build.patch
	epatch "${FILESDIR}"/${P}-solaris.patch
	# no configure around
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e '/^LDLIBS+=/s/$/ -lsocket/' Makefile || die
	fi
	tc-export CC
}

src_install() {
	dobin cvsps
	doman cvsps.1
	dodoc README CHANGELOG
}

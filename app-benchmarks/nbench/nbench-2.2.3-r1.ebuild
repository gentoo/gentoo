# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

MY_P="${PN}-byte-${PV}"
DESCRIPTION="Linux/Unix of release 2 of BYTE Magazine's BYTEmark benchmark"
HOMEPAGE="http://www.tux.org/~mayer/linux/bmark.html"
SRC_URI="http://www.tux.org/~mayer/linux/${MY_P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 sh sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
	sed \
		-e 's:$compiler -v\( 2>&1 | sed -e "/version/!d"\|\):$compiler -dumpversion:' \
		-i sysinfo.sh || die "patching sysinfo.sh failed"
	sed -e 's:inpath="NNET.DAT":inpath="/usr/share/nbench/NNET.DAT":' \
		-i nbench1.h || die "patching nbench1.h failed"
}

src_compile() {
	emake LINKFLAGS="${LDFLAGS}" CC=$(tc-getCC) CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	dobin nbench
	insinto /usr/share/nbench
	doins NNET.DAT
	dodoc Changes README* bdoc.txt
}

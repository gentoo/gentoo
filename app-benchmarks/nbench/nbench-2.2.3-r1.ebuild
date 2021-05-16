# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P="${PN}-byte-${PV}"

DESCRIPTION="Linux/Unix of release 2 of BYTE Magazine's BYTEmark benchmark"
HOMEPAGE="http://www.tux.org/~mayer/linux/bmark.html"
SRC_URI="http://www.tux.org/~mayer/linux/${MY_P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}
PATCHES=( "${FILESDIR}/${P}-Makefile.patch" )

src_prepare() {
	default

	sed \
		-e 's:$compiler -v\( 2>&1 | sed -e "/version/!d"\|\):$compiler -dumpversion:' \
		-i sysinfo.sh || die "patching sysinfo.sh failed"
	sed -e 's:inpath="NNET.DAT":inpath="/usr/share/nbench/NNET.DAT":' \
		-i nbench1.h || die "patching nbench1.h failed"
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin nbench
	dodoc Changes README* bdoc.txt

	insinto /usr/share/nbench
	doins NNET.DAT
}

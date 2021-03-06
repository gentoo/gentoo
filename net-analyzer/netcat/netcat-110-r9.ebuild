# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs flag-o-matic

PATCH_VER="1.0"
MY_P=nc${PV}
DESCRIPTION="the network swiss army knife"
HOMEPAGE="https://nc110.sourceforge.io"
SRC_URI="mirror://sourceforge/nc110/${MY_P}.tgz
	ftp://sith.mimuw.edu.pl/pub/users/baggins/IPv6/nc-v6-20000918.patch.gz
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.bz2"

LICENSE="netcat"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc64-solaris ~x64-solaris"
IUSE="crypt ipv6 static"

LIB_DEPEND="crypt? ( dev-libs/libmix[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

S=${WORKDIR}

src_prepare() {
	epatch "${DISTDIR}"/nc-v6-20000918.patch.gz patch
	sed -i 's:#define HAVE_BIND:#undef HAVE_BIND:' netcat.c
	sed -i 's:#define FD_SETSIZE 16:#define FD_SETSIZE 1024:' netcat.c #34250
	[[ ${CHOST} == *-solaris* ]] && \
		sed -i 's:gethostbyname2(\([^)]\+\)):getipnodebyname(\1, AI_DEFAULT, NULL):' netcat.c
}

src_compile() {
	export XLIBS=""
	export XFLAGS="-DLINUX -DTELNET -DGAPING_SECURITY_HOLE"
	use ipv6 && XFLAGS="${XFLAGS} -DINET6"
	use static && export STATIC="-static"
	use crypt && XFLAGS="${XFLAGS} -DAESCRYPT" && XLIBS="${XLIBS} -lmix"
	[[ ${CHOST} == *-solaris* ]] && XLIBS="${XLIBS} -lnsl -lsocket"
	emake -e CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" nc
}

src_install() {
	dobin nc
	dodoc README* netcat.blurb debian-*
	doman nc.1
	docinto scripts
	dodoc scripts/*
}

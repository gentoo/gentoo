# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

PATCH_VER="1.0"
MY_P=nc${PV}
DESCRIPTION="The network swiss army knife"
HOMEPAGE="https://nc110.sourceforge.io"
SRC_URI="mirror://sourceforge/nc110/${MY_P}.tgz
	ftp://sith.mimuw.edu.pl/pub/users/baggins/IPv6/nc-v6-20000918.patch.gz
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.bz2
"
S="${WORKDIR}"

LICENSE="netcat"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc64-solaris ~x64-solaris"
IUSE="crypt ipv6 static"

LIB_DEPEND="crypt? ( dev-libs/libmix[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"

src_prepare() {
	default

	eapply "${WORKDIR}"/nc-v6-20000918.patch

	sed -i 's:#define HAVE_BIND:#undef HAVE_BIND:' netcat.c
	# bug 34250
	sed -i 's:#define FD_SETSIZE 16:#define FD_SETSIZE 1024:' netcat.c

	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i 's:gethostbyname2(\([^)]\+\)):getipnodebyname(\1, AI_DEFAULT, NULL):' netcat.c || die
	fi
}

src_compile() {
	export XLIBS=""
	export XFLAGS="-DLINUX -DTELNET -DGAPING_SECURITY_HOLE"

	if use ipv6 ; then
		XFLAGS+=" -DINET6"
	fi

	if use static ; then
		export STATIC="-static"
	fi

	if use crypt ; then
		XFLAGS+=" -DAESCRYPT"
		XLIBS+=" -lmix"
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		XLIBS+=" -lnsl -lsocket"
	fi

	emake -e CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" nc
}

src_install() {
	dobin nc
	dodoc README* netcat.blurb debian-*
	doman nc.1
	docinto scripts
	dodoc scripts/*
}

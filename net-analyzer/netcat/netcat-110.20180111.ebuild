# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs flag-o-matic

MY_P="nc${PV}"
DESCRIPTION="the network swiss army knife"
HOMEPAGE="https://nc110.sourceforge.io"
SRC_URI="mirror://sourceforge/nc110/${MY_P}.tar.xz"

LICENSE="netcat"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc64-solaris ~x64-solaris"
IUSE="ipv6 static"

S=${WORKDIR}/nc110

src_prepare() {
	sed -i \
		-e '/#define HAVE_BIND/s:#define:#undef:' \
		-e '/#define FD_SETSIZE 16/s:16:1024: #34250' \
		netcat.c || die
	[[ ${CHOST} == *-solaris* ]] && \
		sed -i 's:gethostbyname2 *(\([^)]\+\)):getipnodebyname (\1, AI_DEFAULT, NULL):' netcat.c
}

src_configure() {
	use ipv6 || sed -i '/#define INET6/d' generic.h
	append-cppflags -DTELNET -DGAPING_SECURITY_HOLE
}

src_compile() {
	local xlibs
	[[ ${CHOST} == *-solaris* ]] && xlibs+=" -lnsl -lsocket"
	emake \
		LD="$(tc-getCC) ${LDFLAGS}" \
		DFLAGS="${CPPFLAGS}" \
		XFLAGS="${CFLAGS}" \
		STATIC=$(usex static '-static' '') \
		XLIBS="${xlibs}" \
		nc
}

src_install() {
	dobin nc
	dodoc README* netcat.blurb
	doman nc.1
	docinto scripts
	dodoc scripts/*
}

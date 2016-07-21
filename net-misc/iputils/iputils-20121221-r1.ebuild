# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# For released versions, we precompile the man/html pages and store
# them in a tarball on our mirrors.  This avoids ugly issues while
# building stages, and when the jade/sgml packages are broken (which
# seems to be more common than would be nice).

EAPI="4"

inherit flag-o-matic eutils toolchain-funcs fcaps
if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="git://www.linux-ipv6.org/gitroot/iputils"
	inherit git-2
else
	SRC_URI="http://www.skbuff.net/iputils/iputils-s${PV}.tar.bz2
		mirror://gentoo/iputils-s${PV}-manpages.tar.bz2"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="http://www.linuxfoundation.org/collaborate/workgroups/networking/iputils"

LICENSE="BSD-4"
SLOT="0"
IUSE="caps doc gnutls idn ipv6 SECURITY_HAZARD ssl static"

LIB_DEPEND="caps? ( sys-libs/libcap[static-libs(+)] )
	idn? ( net-dns/libidn[static-libs(+)] )
	ipv6? ( ssl? (
		gnutls? (
			net-libs/gnutls[openssl(+)]
			net-libs/gnutls[static-libs(+)]
		)
		!gnutls? ( dev-libs/openssl:0[static-libs(+)] )
	) )"
RDEPEND="!net-misc/rarpd
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	virtual/os-headers"
if [[ ${PV} == "99999999" ]] ; then
	DEPEND+="
		app-text/openjade
		dev-perl/SGMLSpm
		app-text/docbook-sgml-dtd
		app-text/docbook-sgml-utils
	"
fi

S=${WORKDIR}/${PN}-s${PV}

src_prepare() {
	epatch "${FILESDIR}"/021109-uclibc-no-ether_ntohost.patch
	epatch "${FILESDIR}"/${PN}-20121221-openssl.patch #335436
	epatch "${FILESDIR}"/${PN}-20121221-crypto-build.patch
	epatch "${FILESDIR}"/${PN}-20100418-so_mark.patch #335347
	epatch "${FILESDIR}"/${PN}-20121221-makefile.patch
	epatch "${FILESDIR}"/${PN}-20121221-printf-size.patch
	epatch "${FILESDIR}"/${PN}-20121221-owl-pingsock.diff
	use SECURITY_HAZARD && epatch "${FILESDIR}"/${PN}-20071127-nonroot-floodping.patch
	use static && append-ldflags -static
}

src_compile() {
	tc-export CC
	emake \
		USE_CAP=$(usex caps) \
		USE_IDN=$(usex idn) \
		USE_GNUTLS=$(usex gnutls) \
		USE_CRYPTO=$(usex ssl) \
		$(use ipv6 || echo IPV6_TARGETS=)

	if [[ ${PV} == "99999999" ]] ; then
		emake -j1 html man
	fi
}

ipv6() { usex ipv6 "$*" '' ; }

src_install() {
	into /
	dobin arping ping $(ipv6 ping6)
	into /usr
	dobin clockdiff
	dosbin rarpd rdisc ipg tftpd tracepath $(ipv6 tracepath6)

	dodoc INSTALL RELNOTES
	use ipv6 \
		&& dosym ping.8 /usr/share/man/man8/ping6.8 \
		|| rm -f doc/*6.8
	rm -f doc/{setkey,traceroute6}.8
	doman doc/*.8

	use doc && dohtml doc/*.html
}

pkg_postinst() {
	fcaps cap_net_raw \
		bin/{ar,}ping \
		$(ipv6 bin/ping6) \
		usr/bin/clockdiff
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# For released versions, we precompile the man/html pages and store
# them in a tarball on our mirrors.  This avoids ugly issues while
# building stages, and when the jade/sgml packages are broken (which
# seems to be more common than would be nice).
# Required packages for doc generation:
# app-text/docbook-sgml-utils

EAPI=5

inherit flag-o-matic eutils toolchain-funcs fcaps
if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="https://github.com/iputils/iputils.git"
	inherit git-r3
else
	SRC_URI="https://github.com/iputils/iputils/archive/s${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~polynomial-c/iputils-s${PV}-manpages.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/iputils"

LICENSE="BSD-4"
SLOT="0"
IUSE="arping caps clockdiff doc gcrypt idn ipv6 libressl nettle +openssl rarpd rdisc SECURITY_HAZARD ssl static tftpd tracepath traceroute"

LIB_DEPEND="caps? ( sys-libs/libcap[static-libs(+)] )
	idn? ( net-dns/libidn[static-libs(+)] )
	ipv6? ( ssl? (
		gcrypt? ( dev-libs/libgcrypt:0=[static-libs(+)] )
		nettle? ( dev-libs/nettle[static-libs(+)] )
		openssl? (
			!libressl? ( dev-libs/openssl:0[static-libs(+)] )
			libressl? ( dev-libs/libressl[static-libs(+)] )
		)
	) )"
RDEPEND="arping? ( !net-misc/arping )
	rarpd? ( !net-misc/rarpd )
	traceroute? ( !net-analyzer/traceroute )
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

REQUIRED_USE="ipv6? ( ssl? ( ^^ ( gcrypt nettle openssl ) ) )"

S=${WORKDIR}/${PN}-s${PV}

PATCHES=(
	"${FILESDIR}/021109-uclibc-no-ether_ntohost.patch"
)

src_prepare() {
	epatch ${PATCHES[@]}
	use SECURITY_HAZARD && epatch "${FILESDIR}"/${PN}-20150815-nonroot-floodping.patch
}

src_configure() {
	use static && append-ldflags -static

	TARGETS=(
		ping
		$(for v in arping clockdiff rarpd rdisc tftpd tracepath ; do usev ${v} ; done)
	)
	if use ipv6 ; then
		TARGETS+=(
			$(usex tracepath 'tracepath6' '')
			$(usex traceroute 'traceroute6' '')
		)
	fi

	myconf=(
		USE_CRYPTO=no
		USE_GCRYPT=no
		USE_NETTLE=no
	)

	if use ipv6 && use ssl ; then
		myconf=(
			USE_CRYPTO=$(usex openssl)
			USE_GCRYPT=$(usex gcrypt)
			USE_NETTLE=$(usex nettle)
		)
	fi
}

src_compile() {
	tc-export CC
	emake \
		USE_CAP=$(usex caps) \
		USE_IDN=$(usex idn) \
		IPV4_DEFAULT=$(usex ipv6 'no' 'yes') \
		TARGETS="${TARGETS[*]}" \
		${myconf[@]}

	if [[ ${PV} == "99999999" ]] ; then
		emake html man
	fi
}

src_install() {
	into /
	dobin ping
	dosym ping /bin/ping4
	if use ipv6 ; then
		dosym ping /bin/ping6
		dosym ping.8 /usr/share/man/man8/ping6.8
	fi
	doman doc/ping.8

	if use arping ; then
		dobin arping
		doman doc/arping.8
	fi

	into /usr

	local u
	for u in clockdiff rarpd rdisc tftpd tracepath ; do
		if use ${u} ; then
			case ${u} in
			clockdiff) dobin ${u};;
			*) dosbin ${u};;
			esac
			doman doc/${u}.8
		fi
	done

	if use tracepath && use ipv6 ; then
		dosbin tracepath6
		dosym tracepath.8 /usr/share/man/man8/tracepath6.8
	fi

	if use traceroute && use ipv6 ; then
		dosbin traceroute6
		doman doc/traceroute6.8
	fi

	if use rarpd ; then
		newinitd "${FILESDIR}"/rarpd.init.d rarpd
		newconfd "${FILESDIR}"/rarpd.conf.d rarpd
	fi

	dodoc INSTALL RELNOTES

	use doc && dohtml doc/*.html
}

pkg_postinst() {
	fcaps cap_net_raw \
		bin/ping \
		$(usex arping 'bin/arping' '') \
		$(usex clockdiff 'usr/bin/clockdiff' '')
}

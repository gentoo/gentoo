# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# For released versions, we precompile the man/html pages and store
# them in a tarball on our mirrors.  This avoids ugly issues while
# building stages, and when the jade/sgml packages are broken (which
# seems to be more common than would be nice).

EAPI=5

inherit flag-o-matic eutils toolchain-funcs fcaps
if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="git://www.linux-ipv6.org/gitroot/iputils"
	inherit git-2
else
	SRC_URI="http://www.skbuff.net/iputils/iputils-s${PV}.tar.bz2
		https://dev.gentoo.org/~polynomial-c/iputils-s${PV}-manpages.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="http://www.linuxfoundation.org/collaborate/workgroups/networking/iputils"

LICENSE="BSD-4"
SLOT="0"
IUSE="arping caps clockdiff doc gcrypt idn ipv6 libressl rarpd rdisc SECURITY_HAZARD ssl static tftpd tracepath traceroute"

LIB_DEPEND="caps? ( sys-libs/libcap[static-libs(+)] )
	idn? ( net-dns/libidn[static-libs(+)] )
	ipv6? ( ssl? (
		gcrypt? ( dev-libs/libgcrypt:0=[static-libs(+)] )
		!gcrypt? (
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

S=${WORKDIR}/${PN}-s${PV}

PATCHES=(
	"${FILESDIR}"/021109-uclibc-no-ether_ntohost.patch
	"${FILESDIR}"/${PN}-99999999-openssl.patch #335436
	"${FILESDIR}"/${PN}-99999999-tftpd-syslog.patch
	"${FILESDIR}"/${PN}-20121221-makefile.patch
	"${FILESDIR}"/${PN}-20121221-parallel-doc.patch
	"${FILESDIR}"/${PN}-20121221-strtod.patch #472592
)

src_prepare() {
	use SECURITY_HAZARD && PATCHES+=( "${FILESDIR}"/${PN}-20071127-nonroot-floodping.patch )
	epatch "${PATCHES[@]}"
}

src_configure() {
	use static && append-ldflags -static

	IPV4_TARGETS=(
		ping
		$(for v in arping clockdiff rarpd rdisc tftpd tracepath ; do usev ${v} ; done)
	)
	IPV6_TARGETS=(
		ping6
		$(usex tracepath 'tracepath6' '')
		$(usex traceroute 'traceroute6' '')
	)
	use ipv6 || IPV6_TARGETS=()
}

ldflag_resolv() {
	# See if the system includes a libresolv. #584132
	echo "main(){}" > "${T}"/resolv.c
	if ${CC} ${CFLAGS} ${LDFLAGS} "${T}"/resolv.c -lresolv -o "${T}"/resolv 2>/dev/null ; then
		echo -lresolv
	fi
}

src_compile() {
	tc-export CC
	emake \
		USE_CAP=$(usex caps) \
		USE_IDN=$(usex idn) \
		USE_GCRYPT=$(usex gcrypt) \
		USE_CRYPTO=$(usex ssl) \
		LDFLAG_RESOLV=$(ldflag_resolv) \
		IPV4_TARGETS="${IPV4_TARGETS[*]}" \
		IPV6_TARGETS="${IPV6_TARGETS[*]}"

	if [[ ${PV} == "99999999" ]] ; then
		emake html man
	fi
}

src_install() {
	into /
	dobin ping $(usex ipv6 'ping6' '')
	use ipv6 && dosym ping.8 "${EPREFIX}"/usr/share/man/man8/ping6.8
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
		dosym tracepath.8 "${EPREFIX}"/usr/share/man/man8/tracepath6.8
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
		$(usex ipv6 'bin/ping6' '') \
		$(usex arping 'bin/arping' '') \
		$(usex clockdiff 'usr/bin/clockdiff' '')
}

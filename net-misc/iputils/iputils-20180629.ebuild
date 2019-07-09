# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# For released versions, we precompile the man/html pages and store
# them in a tarball on our mirrors.  This avoids ugly issues while
# building stages, and reduces depedencies.
# To regenerate man/html pages emerge iputils-99999999[doc] with
# EGIT_COMMIT set to release tag and tar ${S}/doc folder.

EAPI="6"

inherit flag-o-matic toolchain-funcs fcaps

MY_PV="${PV/_pre/}"

PATCHES=(
	"${FILESDIR}"/${PN}-20180629-musl.patch
	"${FILESDIR}"/${P}-fix-ping-on-musl.patch
)

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="https://github.com/iputils/iputils.git"
	inherit git-r3
else
	SRC_URI="https://github.com/iputils/iputils/archive/s${MY_PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~whissi/dist/iputils/${PN}-manpages-${MY_PV}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/iputils"

LICENSE="BSD GPL-2+ rdisc"
SLOT="0"
IUSE="+arping caps clockdiff doc gcrypt idn ipv6 libressl nettle rarpd rdisc SECURITY_HAZARD ssl static tftpd tracepath traceroute6"

LIB_DEPEND="caps? ( sys-libs/libcap[static-libs(+)] )
	idn? ( net-dns/libidn2:=[static-libs(+)] )
	ipv6? (
		ssl? (
			gcrypt? ( dev-libs/libgcrypt:0=[static-libs(+)] )
			!gcrypt? (
				nettle? ( dev-libs/nettle[static-libs(+)] )
				!nettle? (
					libressl? ( dev-libs/libressl:0=[static-libs(+)] )
					!libressl? ( dev-libs/openssl:0=[static-libs(+)] )
				)
			)
		)
	)
"
RDEPEND="arping? ( !net-misc/arping )
	rarpd? ( !net-misc/rarpd )
	traceroute6? ( !net-analyzer/traceroute )
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	virtual/os-headers
"
if [[ ${PV} == "99999999" ]] ; then
	DEPEND+="app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt:0
	"
fi

[ "${PV}" = "99999999" ] || S="${WORKDIR}/${PN}-s${PV}"

src_prepare() {
	use SECURITY_HAZARD && PATCHES+=( "${FILESDIR}"/${PN}-20150815-nonroot-floodping.patch )

	default
}

src_configure() {
	use static && append-ldflags -static

	TARGETS=(
		ping
		$(for v in arping clockdiff rarpd rdisc tftpd tracepath ; do usev ${v} ; done)
	)
	if use ipv6 ; then
		TARGETS+=(
			$(usex traceroute6 'traceroute6' '')
		)
	fi

	myconf=(
		USE_CRYPTO=no
		USE_GCRYPT=no
		USE_NETTLE=no
	)

	if use ipv6 && use ssl ; then
		myconf=(
			USE_CRYPTO=yes
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
		emake man

		use doc && emake html
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

	if use tracepath ; then
		dosbin tracepath
		doman doc/tracepath.8
		dosym tracepath /usr/sbin/tracepath4
	fi

	local u
	for u in clockdiff rarpd rdisc tftpd ; do
		if use ${u} ; then
			case ${u} in
			clockdiff) dobin ${u};;
			*) dosbin ${u};;
			esac
			doman doc/${u}.8
		fi
	done

	if use tracepath && use ipv6 ; then
		dosym tracepath /usr/sbin/tracepath6
		dosym tracepath.8 /usr/share/man/man8/tracepath6.8
	fi

	if use traceroute6 && use ipv6 ; then
		dosbin traceroute6
		doman doc/traceroute6.8
	fi

	if use rarpd ; then
		newinitd "${FILESDIR}"/rarpd.init.d rarpd
		newconfd "${FILESDIR}"/rarpd.conf.d rarpd
	fi

	dodoc INSTALL.md

	use doc && dodoc doc/*.html
}

pkg_postinst() {
	fcaps cap_net_raw \
		bin/ping \
		$(usex arping 'bin/arping' '') \
		$(usex clockdiff 'usr/bin/clockdiff' '')
}

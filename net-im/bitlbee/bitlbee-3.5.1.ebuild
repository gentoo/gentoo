# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user systemd toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/bitlbee/bitlbee.git"
	inherit git-r3
else
	SRC_URI="https://get.bitlbee.org/src/${P}.tar.gz"
	KEYWORDS="amd64 ppc ~ppc64 x86 ~x86-fbsd"
fi

DESCRIPTION="irc to IM gateway that support multiple IM protocols"
HOMEPAGE="https://www.bitlbee.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE_PROTOCOLS="msn oscar purple twitter +xmpp"
IUSE="debug +gnutls ipv6 libevent libressl nss otr +plugins selinux test xinetd
	${IUSE_PROTOCOLS}"

REQUIRED_USE="
	|| ( purple xmpp msn oscar )
	xmpp? ( !nss )
	test? ( plugins )
"

COMMON_DEPEND="
	>=dev-libs/glib-2.16
	purple? ( net-im/pidgin )
	libevent? ( dev-libs/libevent:= )
	otr? ( >=net-libs/libotr-4 )
	gnutls? ( net-libs/gnutls:= )
	!gnutls? (
		nss? ( dev-libs/nss )
		!nss? (
			libressl? ( dev-libs/libressl:= )
			!libressl? ( dev-libs/openssl:0= )
		)
	)
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	selinux? ( sec-policy/selinux-bitlbee )
	test? ( dev-libs/check )"

RDEPEND="${COMMON_DEPEND}
	virtual/logger
	xinetd? ( sys-apps/xinetd )"

pkg_setup() {
	enewgroup bitlbee
	enewuser bitlbee -1 -1 /var/lib/bitlbee bitlbee
}

src_prepare() {
	if [[ ${PV} != "9999" ]]; then
		eapply \
			"${FILESDIR}"/${PN}-3.5-systemd-user.patch \
			"${FILESDIR}"/${PN}-3.5-verbose-build.patch
	fi

	eapply_user
}

src_configure() {
	local myconf

	# setup plugins, protocol, ipv6 and debug
	myconf+=( --jabber=$(usex xmpp 1 0) )
	for flag in debug ipv6 plugins ${IUSE_PROTOCOLS/+xmpp/} ; do
		myconf+=( --${flag}=$(usex ${flag} 1 0) )
	done

	# set otr
	if use otr && use plugins ; then
		myconf+=( --otr=plugin )
	else
		if use otr ; then
			ewarn "OTR support has been disabled automatically because it"
			ewarn "requires the plugins USE flag."
		fi
		myconf+=( --otr=0 )
	fi

	# setup ssl use flags
	if use gnutls ; then
		myconf+=( --ssl=gnutls )
		einfo "Using gnutls for SSL support"
	else
		ewarn "Only gnutls is officially supported by upstream."
		if use nss ; then
			myconf+=( --ssl=nss )
			einfo "Using nss for SSL support"
		else
			myconf+=( --ssl=openssl )
			einfo "Using openssl for SSL support"
		fi
	fi

	# set event handler
	if use libevent ; then
		myconf+=( --events=libevent )
	else
		myconf+=( --events=glib )
	fi

	# not autotools-based
	./configure \
		--prefix=/usr \
		--datadir=/usr/share/bitlbee \
		--etcdir=/etc/bitlbee \
		--plugindir=/usr/$(get_libdir)/bitlbee \
		--systemdsystemunitdir=$(systemd_get_systemunitdir) \
		--doc=1 \
		--strip=0 \
		--verbose=1 \
		"${myconf[@]}" || die

	sed -i \
		-e "/^EFLAGS/s:=:&${LDFLAGS} :" \
		Makefile.settings || die
}

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	emake DESTDIR="${D}" install install-etc install-doc install-dev install-systemd

	keepdir /var/lib/bitlbee
	fperms 700 /var/lib/bitlbee
	fowners bitlbee:bitlbee /var/lib/bitlbee

	dodoc doc/{AUTHORS,CHANGES,CREDITS,FAQ,README}

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins doc/bitlbee.xinetd bitlbee
	fi

	newinitd "${FILESDIR}"/bitlbee.initd-r1 bitlbee
	newconfd "${FILESDIR}"/bitlbee.confd-r1 bitlbee

	exeinto /usr/share/bitlbee
	doexe utils/{convert_purple.py,bitlbee-ctl.pl}
}

pkg_postinst() {
	chown -R bitlbee:bitlbee "${ROOT}"/var/lib/bitlbee
	[[ -d "${ROOT}"/var/run/bitlbee ]] &&
		chown -R bitlbee:bitlbee "${ROOT}"/var/run/bitlbee

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		einfo
		elog "The bitlbee init script will now attempt to stop all processes owned by the"
		elog "bitlbee user, including per-client forks."
		elog
		elog "Tell the init script not to touch anything besides the main bitlbee process"
		elog "by changing the BITLBEE_STOP_ALL variable in"
		elog "	/etc/conf.d/bitlbee"
		einfo
	fi
}

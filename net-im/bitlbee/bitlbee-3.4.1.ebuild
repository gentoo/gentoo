# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils multilib user python-single-r1 systemd

DESCRIPTION="irc to IM gateway that support multiple IM protocols"
HOMEPAGE="http://www.bitlbee.org/"
SRC_URI="http://get.bitlbee.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="debug gnutls ipv6 +xmpp libevent msn nss +oscar otr +plugins purple selinux
	skype ssl test twitter +yahoo xinetd"

COMMON_DEPEND="
	>=dev-libs/glib-2.16
	purple? ( net-im/pidgin )
	libevent? ( dev-libs/libevent )
	otr? ( >=net-libs/libotr-4 )
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		nss? ( dev-libs/nss )
		!nss? ( ssl? ( dev-libs/openssl:0 ) )
	)
	"
DEPEND="${COMMON_DEPEND}
	dev-lang/python
	virtual/pkgconfig
	selinux? ( sec-policy/selinux-bitlbee )
	test? ( dev-libs/check )"

RDEPEND="${COMMON_DEPEND}
	virtual/logger
	skype? (
		dev-python/skype4py[${PYTHON_USEDEP}]
		net-im/skype
	)
	xinetd? ( sys-apps/xinetd )"

REQUIRED_USE="|| ( purple xmpp msn oscar yahoo )
	msn? ( || ( gnutls nss ssl ) )
	xmpp? ( !nss )"

pkg_setup() {
	if use xmpp && ! use gnutls && ! use ssl ; then
		einfo
		elog "You have enabled support for Jabber but do not have SSL"
		elog "support enabled.  This *will* prevent bitlbee from being"
		elog "able to connect to SSL enabled Jabber servers.  If you need to"
		elog "connect to Jabber over SSL, enable ONE of the following use"
		elog "flags: gnutls or ssl"
		einfo
	fi

	use skype && python-single-r1_pkg_setup

	enewgroup bitlbee
	enewuser bitlbee -1 -1 /var/lib/bitlbee bitlbee
}

src_prepare() {
	sed -i \
		-e "s@/usr/local/sbin/bitlbee@/usr/sbin/bitlbee@" \
		-e "s/nobody/bitlbee/" \
		-e "s/}/	disable         = yes\n}/" \
		doc/bitlbee.xinetd || die "sed failed in xinetd"

	sed -i \
		-e "s@mozilla-nss@nss@g" \
		configure || die "sed failed in configure"

	use skype && python_fix_shebang protocols/skype/skyped.py

	epatch "${FILESDIR}"/${PN}-3.2.1-configure.patch
}

src_configure() {
	# setup plugins, protocol, ipv6 and debug
	use xmpp && myconf="${myconf} --jabber=1"
	for flag in debug ipv6 msn oscar plugins purple skype twitter yahoo ; do
		if use ${flag} ; then
			myconf="${myconf} --${flag}=1"
		else
			myconf="${myconf} --${flag}=0"
		fi
	done

	# set otr
	if use otr && use plugins ; then
		myconf="${myconf} --otr=plugin"
	else
		if use otr ; then
			ewarn "OTR support has been disabled automatically because it"
			ewarn "requires the plugins USE flag."
		fi
		myconf="${myconf} --otr=0"
	fi

	# setup ssl use flags
	if use gnutls ; then
		myconf="${myconf} --ssl=gnutls"
		einfo "Using gnutls for SSL support"
	elif use ssl ; then
		myconf="${myconf} --ssl=openssl"
		einfo "Using openssl for SSL support"
	elif use nss ; then
		myconf="${myconf} --ssl=nss"
		einfo "Using nss for SSL support"
	else
		myconf="${myconf} --ssl=bogus"
		einfo "You will not have any encryption support enabled."
	fi

	# set event handler
	if use libevent ; then
		myconf="${myconf} --events=libevent"
	else
		myconf="${myconf} --events=glib"
	fi

	# NOTE: bitlbee's configure script is not an autotool creation,
	# so that is why we don't use econf.
	./configure \
		--prefix=/usr --datadir=/usr/share/bitlbee \
		--etcdir=/etc/bitlbee --plugindir=/usr/$(get_libdir)/bitlbee \
		--systemdsystemunitdir=$(systemd_get_unitdir) \
		--doc=1 --strip=0 ${myconf} || die "econf failed"

	sed -i \
		-e "/^EFLAGS/s:=:&${LDFLAGS} :" \
		Makefile.settings || die "sed failed"
}

src_install() {
	emake install install-etc install-doc install-dev install-systemd DESTDIR="${D}"

	keepdir /var/lib/bitlbee
	fperms 700 /var/lib/bitlbee
	fowners bitlbee:bitlbee /var/lib/bitlbee

	dodoc doc/{AUTHORS,CHANGES,CREDITS,FAQ,README}

	if use skype ; then
		newdoc protocols/skype/NEWS NEWS-skype
		newdoc protocols/skype/README README-skype
	fi

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

	einfo
	elog "The bitlbee init script will now attempt to stop all processes owned by the"
	elog "bitlbee user, including per-client forks."
	elog
	elog "Tell the init script not to touch anything besides the main bitlbee process"
	elog "by changing the BITLBEE_STOP_ALL variable in"
	elog "	/etc/conf.d/bitlbee"
	einfo
}

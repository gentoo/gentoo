# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-plugins/nagios-plugins-1.4.16-r3.ebuild,v 1.6 2015/05/16 10:36:02 pacho Exp $

EAPI=4

PATCHSET=2

inherit autotools eutils multilib user

DESCRIPTION="Nagios $PV plugins - Pack of plugins to make Nagios work properly"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagiosplug/${P}.tar.gz
	http://dev.gentoo.org/~flameeyes/${PN}/${P}-patches-${PATCHSET}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="+ssl samba mysql postgres ldap snmp nagios-dns nagios-ntp nagios-ping nagios-ssh nagios-game ups ipv6 radius +suid xmpp gnutls sudo smart"

DEPEND="ldap? ( >=net-nds/openldap-2.0.25 )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	ssl? (
		!gnutls? ( >=dev-libs/openssl-0.9.6g )
		gnutls? ( net-libs/gnutls )
	)
	radius? ( >=net-dialup/radiusclient-0.3.2 )"

# tests try to ssh into the box itself
RESTRICT="test"

RDEPEND="${DEPEND}
	>=dev-lang/perl-5.6.1-r7
	samba? ( >=net-fs/samba-2.2.5-r1 )
	snmp? ( >=dev-perl/Net-SNMP-4.0.1-r1 )
	mysql? ( dev-perl/DBI
			 dev-perl/DBD-mysql )
	nagios-dns? ( >=net-dns/bind-tools-9.2.2_rc1 )
	nagios-ntp? ( >=net-misc/ntp-4.1.1a )
	nagios-ping? ( >=net-analyzer/fping-2.4_beta2-r1 )
	nagios-ssh? ( >=net-misc/openssh-3.5_p1 )
	ups? ( >=sys-power/nut-1.4 )
	nagios-game? ( >=games-util/qstat-2.6 )
	xmpp? ( >=dev-perl/Net-Jabber-2.0 )
	sudo? ( >=app-admin/sudo-1.8.5 )
	smart? ( sys-apps/smartmontools )"

REQUIRED_USE="smart? ( sudo )"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_prepare() {
	epatch "${WORKDIR}"/patches/*.patch

	eautoreconf
}

src_configure() {
	local myconf
	if use ssl; then
		myconf+="
			$(use_with !gnutls openssl /usr)
			$(use_with gnutls gnutls /usr)"
	else
		myconf+=" --without-openssl --without-gnutls"
	fi

	econf \
		$(use_with mysql) \
		$(use_with ipv6) \
		$(use_with ldap) \
		$(use_with radius) \
		$(use_with postgres pgsql /usr) \
		${myconf} \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--sysconfdir=/etc/nagios
}

DOCS=( ACKNOWLEDGEMENTS AUTHORS BUGS CODING ChangeLog FAQ NEWS README REQUIREMENTS SUPPORT THANKS )

src_install() {
	default

	local nagiosplugindir=/usr/$(get_libdir)/nagios/plugins

	if use sudo; then
		cat - > "${T}"/50${PN} <<EOF
# we add /bin/false so that we don't risk causing syntax errors if all USE flags
# are off as we'd end up with an empty set
Cmnd_Alias NAGIOS_PLUGINS_CMDS = /bin/false $(use smart && echo ", /usr/sbin/smartctl")
User_Alias NAGIOS_PLUGINS_USERS = nagios, icinga

NAGIOS_PLUGINS_USERS ALL=(root) NOPASSWD: NAGIOS_PLUGINS_CMDS
EOF

		insinto /etc/sudoers.d
		doins "${T}"/50${PN}
	fi

	cd contrib/
	dodoc *README*

	# remove stuff that is way too broken to fix, or for which the USE
	# flag has been removed.
	rm -r tarballs aix \
		check_compaq_insight.pl *.c *README* \
		$(usex !xmpp nagios_sendim.pl) \
		$(usex !smart check_smart.pl)

	# fix perl interpreter
	sed -i -e '1s:/usr/local/bin/perl:/usr/bin/perl:' \
		"${S}"/contrib/* || die

	exeinto ${nagiosplugindir}/contrib
	doexe *

	dosym ../utils.sh ${nagiosplugindir}/contrib/utils.sh
	dosym ../utils.pm ${nagiosplugindir}/contrib/utils.pm

	# enforce permissions/owners (seem to trigger only in some case)
	chown -R root:nagios "${D}${nagiosplugindir}" || die
	chmod -R o-rwx "${D}${nagiosplugindir}" || die

	use suid && fperms 04710 ${nagiosplugindir}/check_{icmp,ide_smart,dhcp}
}

pkg_postinst() {
	elog "This ebuild has a number of USE flags which determines what nagios is able to monitor."
	elog "Depending on what you want to monitor with nagios, some or all of these USE"
	elog "flags need to be set for nagios to function correctly."
	elog "contrib plugins are installed into /usr/$(get_libdir)/nagios/plugins/contrib"
}

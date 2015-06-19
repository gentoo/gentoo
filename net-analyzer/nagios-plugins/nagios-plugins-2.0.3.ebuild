# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-plugins/nagios-plugins-2.0.3.ebuild,v 1.2 2014/12/29 02:32:31 patrick Exp $

EAPI=5

inherit eutils multilib user

DESCRIPTION="Official set of plugins for Nagios"
HOMEPAGE="http://nagios-plugins.org/"
SRC_URI="http://nagios-plugins.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6 ldap mysql nagios-dns nagios-ping nagios-game postgres samba snmp ssh +ssl"

DEPEND="ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	ssl? ( dev-libs/openssl )"

# tests try to ssh into the box itself
RESTRICT="test"

RDEPEND="${DEPEND}
	dev-lang/perl
	mysql? ( virtual/mysql )
	nagios-dns? ( net-dns/bind-tools )
	nagios-ping? ( net-analyzer/fping )
	nagios-game? ( games-util/qstat )
	samba? ( net-fs/samba )
	snmp? ( dev-perl/Net-SNMP )
	ssh? ( net-misc/openssh )"

src_prepare() {
	# Fix the path to our perl interpreter
	sed -i -e '1s:/usr/local/bin/perl:/usr/bin/perl:' \
		"${S}"/plugins-scripts/*.pl || die
}

src_configure() {
	if use ssl; then
		myconf+="$(use_with ssl openssl /usr)"
	else
		myconf+=" --without-openssl --without-gnutls"
	fi

	econf \
		$(use_with mysql) \
		$(use_with ipv6) \
		$(use_with ldap) \
		$(use_with postgres pgsql /usr) \
		${myconf} \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--sysconfdir=/etc/nagios
}

DOCS=( ACKNOWLEDGEMENTS AUTHORS CODING ChangeLog FAQ \
		NEWS README REQUIREMENTS SUPPORT THANKS )

pkg_preinst() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

pkg_postinst() {
	elog "This ebuild has a number of USE flags which determines what nagios"
	elog "is able to monitor. Depending on what you want to monitor with"
	elog "nagios, some or all of these USE flags need to be set for nagios"
	elog "to function correctly. Plugins are installed into"
	elog "/usr/$(get_libdir)/nagios/plugins"
}

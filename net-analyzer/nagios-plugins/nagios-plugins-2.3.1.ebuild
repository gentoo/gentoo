# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="Official plugins for Nagios"
HOMEPAGE="http://nagios-plugins.org/"
SRC_URI="http://nagios-plugins.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6 ldap libressl mysql nagios-dns nagios-ping nagios-game postgres radius samba selinux snmp ssh +ssl"

# Most of the plugins use automagic dependencies, i.e. the plugin will
# get built if the binary it uses is installed. For example, check_snmp
# will be built only if snmpget from net-analyzer/net-snmp[-minimal] is
# installed. End result: most of our runtime dependencies are required
# at build time as well.
AUTOMAGIC_DEPEND="
	nagios-dns? ( net-dns/bind-tools )
	nagios-game? ( games-util/qstat )
	nagios-ping? ( net-analyzer/fping )
	samba? ( net-fs/samba )
	ssh? ( net-misc/openssh )
	snmp? ( dev-perl/Net-SNMP
			net-analyzer/net-snmp[-minimal] )"

# Perl really needs to run during the build...
BDEPEND="${AUTOMAGIC_DEPEND}
	dev-lang/perl"

DEPEND="
	ldap? ( net-nds/openldap )
	mysql? ( dev-db/mysql-connector-c )
	postgres? ( dev-db/postgresql:* )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	radius? ( net-dialup/freeradius-client )"

# Basically everything in net-analyzer/monitoring-plugins collides with
# nagios-plugins. Perl (from BDEPEND) is needed at runtime, too.
RDEPEND="${BDEPEND}
	${DEPEND}
	!net-analyzer/monitoring-plugins
	selinux? ( sec-policy/selinux-nagios )"

# At least one test is interactive.
RESTRICT="test"

DOCS=(
	ACKNOWLEDGEMENTS
	AUTHORS
	CODING
	ChangeLog
	FAQ
	NEWS
	README
	REQUIREMENTS
	SUPPORT
	THANKS
)

PATCHES=( "${FILESDIR}/define-own-mysql-port-constant.patch" )

src_prepare() {
	default

	# Fix the path to our perl interpreter
	sed -i -e "1s:/usr/local/bin/perl:/usr/bin/perl:" \
		"${S}"/plugins-scripts/*.pl \
		|| die 'failed to fix perl interpreter path'
}

src_configure() {
	# Use an array to prevent econf from mangling the ping args.
	local myconf=()

	if use ssl; then
		myconf+=( $(use_with ssl openssl /usr) )
	else
		myconf+=( --without-openssl )
		myconf+=( --without-gnutls )
	fi

	# The autodetection for these two commands can hang if localhost is
	# down or ICMP traffic is filtered. Bug #468296.
	myconf+=( --with-ping-command="/bin/ping -n -U -w %d -c %d %s" )

	if use ipv6; then
		myconf+=( --with-ping6-command="/bin/ping6 -n -U -w %d -c %d %s" )
	fi

	econf \
		$(use_with mysql) \
		$(use_with ipv6) \
		$(use_with ldap) \
		$(use_with postgres pgsql /usr) \
		$(use_with radius) \
		"${myconf[@]}" \
		--libexecdir="/usr/$(get_libdir)/nagios/plugins" \
		--sysconfdir="/etc/nagios"
}

pkg_preinst() {
	enewgroup nagios
	enewuser nagios -1 -1 -1 nagios
}

pkg_postinst() {
	elog "This ebuild has a number of USE flags that determine what you"
	elog "are able to monitor. Depending on what you want to monitor, some"
	elog "or all of these USE flags need to be set."
	elog
	elog "The plugins are installed in ${ROOT}/usr/$(get_libdir)/nagios/plugins"
}

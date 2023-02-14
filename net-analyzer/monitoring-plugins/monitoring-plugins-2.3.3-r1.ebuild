# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools flag-o-matic

DESCRIPTION="50+ standard plugins for Icinga, Naemon, Nagios, Shinken, Sensu"
HOMEPAGE="https://www.monitoring-plugins.org/"
SRC_URI="https://www.monitoring-plugins.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~sparc ~x86"
IUSE="curl gnutls ipv6 ldap mysql dns fping game postgres radius samba snmp ssh +ssl"

# Most of the plugins use automagic dependencies, i.e. the plugin will
# get built if the binary it uses is installed. For example, check_snmp
# will be built only if snmpget from net-analyzer/net-snmp[-minimal] is
# installed. End result: most of our runtime dependencies are required
# at build time as well.
#
# REAL_DEPEND contains the dependencies that are actually needed to
# build. DEPEND contains those plus the automagic dependencies.
#
REAL_DEPEND="dev-lang/perl
	curl? (
		dev-libs/uriparser
		net-misc/curl
	)
	ldap? ( net-nds/openldap:= )
	mysql? ( || ( dev-db/mysql-connector-c dev-db/mariadb-connector-c ) )
	postgres? ( dev-db/postgresql:= )
	ssl? (
		!gnutls? (
			dev-libs/openssl:0=
		)
		gnutls? ( net-libs/gnutls )
	)
	radius? ( net-dialup/freeradius-client )"

DEPEND="${REAL_DEPEND}
	dns? ( net-dns/bind-tools )
	game? ( games-util/qstat )
	fping? ( net-analyzer/fping )
	samba? ( net-fs/samba )
	ssh? ( net-misc/openssh )
	snmp? ( dev-perl/Net-SNMP
			net-analyzer/net-snmp[-minimal] )"

# Basically everything collides with nagios-plugins.
RDEPEND="${DEPEND}
	acct-group/nagios
	acct-user/nagios
	!net-analyzer/nagios-plugins"
BDEPEND="sys-devel/gettext"

# At least one test is interactive.
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-gnutls.patch" #880211
	"${FILESDIR}/${PN}-fix-check-http-segfault.patch" #893252
)

src_prepare() {
	default

	# Refresh the gettext macro to fix musl build, bug #892645
	# This should be unnecessary in the next release (>2.3.3) as upstream
	# refreshed its copy of gnulib, so on next release:
	# - We may be able to drop the gettext BDEPEND (check!)
	# - Drop this cp call
	# - Drop eautoreconf
	cp "${BROOT}"/usr/share/aclocal/gettext.m4 gl/m4/ || die
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing

	# Use an array to prevent econf from mangling the ping args.
	local myconf=()

	if use ssl; then
		myconf+=( $(use_with !gnutls openssl /usr)
				  $(use_with gnutls gnutls /usr) )
	else
		myconf+=( --without-openssl )
		myconf+=( --without-gnutls )
	fi

	# The autodetection for these two commands can hang if localhost is
	# down or ICMP traffic is filtered (bug #468296). But also the path
	# likes to move around on us (bug #883729).
	myconf+=( --with-ping-command="$(command -v ping) -4 -n -U -w %d -c %d %s" )

	if use ipv6; then
		myconf+=( --with-ping6-command="$(command -v ping) -6 -n -U -w %d -c %d %s" )
	fi

	econf \
		$(use_with curl libcurl) \
		$(use_with curl uriparser) \
		$(use_with mysql) \
		$(use_with ipv6) \
		$(use_with ldap) \
		$(use_with postgres pgsql /usr) \
		$(use_with radius) \
		"${myconf[@]}" \
		--libexecdir="/usr/$(get_libdir)/nagios/plugins" \
		--sysconfdir="/etc/nagios"
}

DOCS=( ACKNOWLEDGEMENTS AUTHORS CODING ChangeLog FAQ \
		NEWS README REQUIREMENTS SUPPORT THANKS )

pkg_postinst() {
	elog "This ebuild has a number of USE flags that determine what you"
	elog "are able to monitor. Depending on what you want to monitor, some"
	elog "or all of these USE flags need to be set."
	elog
	elog "The plugins are installed in ${EROOT}/usr/$(get_libdir)/nagios/plugins"
}

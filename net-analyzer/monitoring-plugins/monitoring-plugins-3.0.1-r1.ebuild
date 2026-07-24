# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps flag-o-matic

DESCRIPTION="50+ standard plugins for Icinga, Naemon, Nagios, Shinken, Sensu"
HOMEPAGE="https://www.monitoring-plugins.org/
	https://github.com/monitoring-plugins/monitoring-plugins/"
SRC_URI="https://www.monitoring-plugins.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc ~x86"
IUSE="curl ipv6 ldap mysql dns fping game postgres radius rpc samba snmp ssh suid"

# Most of the plugins use automagic dependencies, i.e. the plugin will
# get built if the binary it uses is installed. For example, check_snmp
# will be built only if snmpget from net-analyzer/net-snmp[-minimal] is
# installed. End result: most of our runtime dependencies are required
# at build time as well.
#
# REAL_DEPEND contains the dependencies that are actually needed to
# build. DEPEND contains those plus the automagic dependencies.
#
# Note: openssl is required unconditionally because the build fails
# without it:
#
#   * https://github.com/monitoring-plugins/monitoring-plugins/issues/2135
#
REAL_DEPEND="dev-lang/perl
	curl? (
		dev-libs/uriparser
		net-misc/curl
	)
	ldap? ( net-nds/openldap:= )
	mysql? ( || ( dev-db/mysql-connector-c dev-db/mariadb-connector-c ) )
	postgres? ( dev-db/postgresql:= )
	dev-libs/openssl:0=
	radius? ( net-dialup/freeradius-client )"

DEPEND="${REAL_DEPEND}
	dns? ( net-dns/bind )
	game? ( games-util/qstat )
	fping? ( net-analyzer/fping )
	rpc? ( net-nds/rpcbind )
	samba? ( net-fs/samba )
	ssh? ( virtual/openssh )
	snmp? ( dev-perl/Net-SNMP
			net-analyzer/net-snmp[-minimal] )"

# Basically everything collides with nagios-plugins.
RDEPEND="${DEPEND}
	!net-analyzer/nagios-plugins"

# At least one test is interactive.
RESTRICT="test"

# These all come from gnulib and the ./configure checks are working as
# intended when the functions aren't present. Bugs 921190 and 936891.
QA_CONFIG_IMPL_DECL_SKIP=(
	MIN
	fpurge
	static_assert
	statvfs64
	alignof
)

PATCHES=( "${FILESDIR}/${P}-check-ntp-buildfix.patch" )

DOCS=( ACKNOWLEDGEMENTS AUTHORS CODING ChangeLog FAQ \
		NEWS README REQUIREMENTS SUPPORT THANKS )

src_prepare() {
	if ! use snmp; then
		# automagic detection becomes a much bigger problem when the
		# feature breaks the build
		sed -i configure -e '/EXTRAS="\$EXTRAS check_snmp"/d' \
			|| die "failed to disable check_snmp"
	fi
	default
}

src_configure() {
	# https://github.com/monitoring-plugins/monitoring-plugins/issues/2295
	append-flags -fno-strict-aliasing

	# Use an array to prevent econf from mangling the ping args.
	local myconf=()

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
		--with-openssl=/usr \
		--without-gnutls \
		"${myconf[@]}" \
		--libexecdir="/usr/$(get_libdir)/nagios/plugins" \
		--sysconfdir="/etc/nagios"
}

src_install() {
	default

	# Prefer capabilities to suid. Beware that fcaps and fperms require
	# two different kinds of paths; fperms always prepends ${ED}, but
	# fcaps only does so it if the path does not already start with a
	# slash. Anyway, begin by removing suid unconditionally.
	local pd="usr/$(get_libdir)/nagios/plugins"

	if use filecaps; then
		local flags msg
		if use suid; then
			# use suid if setcap fails
			flags="-m u+s"
			msg=" (with suid fallback)"
		fi
		einfo "replacing suid bits with filecaps${msg}"
		fperms ug-s /"${pd}"/check_{dhcp,icmp}
		fcaps ${flags} cap_net_bind_service "${pd}"/check_dhcp
		fcaps ${flags} cap_net_bind_service,cap_net_raw "${pd}"/check_icmp
	else
		# no filecaps, just suid (or not)
		if ! use suid; then
			einfo "stripping suid bits"
			fperms ug-s /"${pd}"/check_{dhcp,icmp}
		fi
	fi
}

pkg_postinst() {
	elog "This ebuild has a number of USE flags that determine what you"
	elog "are able to monitor. Depending on what you want to monitor, some"
	elog "or all of these USE flags need to be set."
	elog
	elog "The plugins are installed in ${EROOT}/usr/$(get_libdir)/nagios/plugins"
}

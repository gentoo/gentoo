# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Official plugins for Nagios"
HOMEPAGE="https://nagios-plugins.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/release-${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="ipv6 ldap mysql nagios-dns nagios-ping nagios-game nls postgres samba selinux snmp ssh +ssl rpc"

# Most of the plugins use automagic dependencies, i.e. the plugin will
# get built if the binary it uses is installed. For example, check_snmp
# will be built only if snmpget from net-analyzer/net-snmp[-minimal] is
# installed. End result: most of our runtime dependencies are required
# at build time as well.
AUTOMAGIC_DEPEND="
	nagios-dns? ( net-dns/bind )
	nagios-game? ( games-util/qstat )
	nagios-ping? ( net-analyzer/fping )
	rpc? ( net-nds/rpcbind )
	samba? ( net-fs/samba )
	ssh? ( virtual/openssh )
	snmp? ( dev-perl/Net-SNMP
			net-analyzer/net-snmp[-minimal] )"

# Perl really needs to run during the build...
BDEPEND="${AUTOMAGIC_DEPEND}
	dev-lang/perl"

DEPEND="
	ldap? ( net-nds/openldap:= )
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	ssl? (
		dev-libs/openssl:0=
	)"

# Basically everything in net-analyzer/monitoring-plugins collides with
# nagios-plugins. Perl (from BDEPEND) is needed at runtime, too.
RDEPEND="${BDEPEND}
	${DEPEND}
	!net-analyzer/monitoring-plugins
	selinux? ( sec-policy/selinux-nagios )"

# At least one test is interactive.
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-postgresql-detection.patch"
	"${FILESDIR}/${P}-snmpgetnext.patch"
)

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

# These all come from gnulib and the ./configure checks are working as
# intended when the functions aren't present. Bugs 907755 and 924341.
QA_CONFIG_IMPL_DECL_SKIP=(
	statvfs64
	re_set_syntax
	re_compile_pattern
	re_search
	re_match
)

src_prepare() {
	default

	# Fix the path to our perl interpreter
	sed -i -e "1s:/usr/local/bin/perl:/usr/bin/perl:" \
		"${S}"/plugins-scripts/*.pl \
		|| die 'failed to fix perl interpreter path'

	eautoreconf

	# eautoreconf replaces $(MKDIR_P) with $(mkdir_p) in
	# po/Makefile.in.in. As you might expect, this does not work.
	sed -i po/Makefile.in.in \
		-e 's/@mkdir_p@/@MKDIR_P@/' \
		|| die
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
	# down or ICMP traffic is filtered (bug #468296). But also the path
	# likes to move around on us (bug #883765).
	myconf+=( --with-ping-command="$(command -v ping) -n -U -w %d -c %d %s" )

	if use ipv6; then
		myconf+=( --with-ping6-command="$(command -v ping6) -n -U -w %d -c %d %s" )
	fi

	# Radius support has been broken for a long time and causes the build
	# to fail (bug 957000, but before that too). I would recommend using
	# net-analyzer/monitoring-plugins if you need check_radius.
	econf \
		$(use_with ipv6) \
		$(use_with ldap) \
		$(use_with mysql) \
		$(use_enable nls) \
		$(use_with postgres pgsql /usr) \
		--without-radius \
		"${myconf[@]}" \
		--libexecdir="/usr/$(get_libdir)/nagios/plugins" \
		--sysconfdir="/etc/nagios"
}

pkg_postinst() {
	elog "This ebuild has a number of USE flags that determine what you"
	elog "are able to monitor. Depending on what you want to monitor, some"
	elog "or all of these USE flags need to be set."
	elog
	elog "The plugins are installed in ${ROOT}/usr/$(get_libdir)/nagios/plugins"
}

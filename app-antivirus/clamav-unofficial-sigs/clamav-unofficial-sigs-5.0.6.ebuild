# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Download and install third-party clamav signatures"
HOMEPAGE="https://github.com/extremeshok/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# We need its user/group.
DEPEND="app-antivirus/clamav"

# The script relies on either net-misc/socat, or Perl's
# IO::Socket::UNIX. We already depend on Perl, and Gentoo's Perl ships
# with IO::Socket::UNIX, so we can leave out net-misc/socat here.
RDEPEND="${DEPEND}
	app-crypt/gnupg
	dev-lang/perl
	net-dns/bind-tools
	net-misc/curl"

src_prepare() {
	# clamd listens on a local socket by default. The clamd_socket
	# setting needs to be uncommented in the configuration file for it
	# to take effect.
	local socket_default="#clamd_socket=\"/var/run/clamav/clamd.sock\""
	local socket_gentoo="clamd_socket=\"/var/run/clamav/clamd.sock\""

	# The clamav init script doesn't provide a "reload" command,
	# so we reload manually.
	local reload_default="clamd_restart_opt=\"service clamd restart\""
	local reload_gentoo="clamd_restart_opt=\"clamdscan --reload\""

	sed -i "config/os.gentoo.conf" \
		-e "s~${socket_default}~${socket_gentoo}~" \
		-e "s~${reload_default}~${reload_gentoo}~" \
		|| die "failed to update config/os.gentoo.conf"

	# Uncomment the "create" line in the logrotate.d file, and tighten
	# the permissions a bit.
	local logrotate_gentoo="     create 0640 clamav clamav"
	sed -e "s~#     create 0644 clamav clamav~${logrotate_gentoo}~" \
		-i "logrotate.d/${PN}" \
		|| die "failed to tighten permissions in logrotate.d/${PN}"

	eapply_user
}

src_install() {
	dosbin "${PN}.sh"

	# The script's working directory (set in the conf file). By default,
	# it runs as clamav/clamav.
	diropts -m 0755 -o clamav -g clamav
	dodir "/var/lib/${PN}"

	insinto /etc/logrotate.d
	doins "logrotate.d/${PN}"

	insinto "/etc/${PN}"
	doins config/master.conf
	newins config/os.gentoo.conf os.conf

	doman "${PN}.8"
	dodoc README.md
}

pkg_postinst() {
	elog ''
	elog "You will need to select databases in /etc/${PN}/master.conf."
	elog "For details, please see the ${PN}(8) manual page."
	elog ''
	elog 'An up-to-date description of the available Sanesecurity'
	elog 'databases is available at,'
	elog ''
	elog '  http://sanesecurity.com/usage/signatures/'
	elog ''
	ewarn 'The configuration file has moved in the 5.x version!'
	ewarn "You should migrate your config from /etc/${PN}.conf to"
	ewarn "/etc/${PN}/master.conf"
	ewarn ''
}

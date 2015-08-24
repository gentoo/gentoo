# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Downloads and installs third-party clamav signatures"
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
	# Fix the user/group in the config file to match the ones used by
	# clamav.
	local user_default="clam_user=\"clam\""
	local user_gentoo="clam_user=\"clamav\""

	local group_default="clam_group=\"clam\""
	local group_gentoo="clam_group=\"clamav\""

	# Log to someplace that (likely) already exists. Omit the
	# "log_file_path" variable name so that we can reuse these patterns
	# later to sed the logrotate file.
	local log_default="/var/log/clamav-unofficial-sigs"
	local log_gentoo="/var/log/clamav"

	# clamd listens on a local socket by default. The clamd_socket
	# setting needs to be uncommented in the configuration file for it
	# to take effect.
	local socket_default="#clamd_socket=\"/var/run/clamd.socket\""
	local socket_gentoo="clamd_socket=\"/var/run/clamav/clamd.sock\""

	sed -i -e "s~${user_default}~${user_gentoo}~" \
		-e "s~${group_default}~${group_gentoo}~" \
		-e "s~${log_default}~${log_gentoo}~" \
		-e "s~${socket_default}~${socket_gentoo}~" \
		"${PN}.conf" \
		|| die "failed to update paths in ${PN}.conf"

	# Fix the log path in the logrotate file, too.
	sed -i -e "s~${log_default}~${log_gentoo}~" "${PN}-logrotate" \
		|| die "failed to update paths in ${PN}-logrotate"
}

src_install() {
	dosbin "${PN}.sh"

	# The script's working directory (set in the conf file). By default,
	# it runs as clamav/clamav.
	diropts -m 0755 -o clamav -g clamav
	dodir "/var/lib/${PN}"

	insinto /etc/logrotate.d
	doins "${PN}-logrotate"

	insinto /etc
	doins "${PN}.conf"

	doman "${PN}.8"
	dodoc CHANGELOG INSTALL README.md
}

pkg_postinst() {
	elog ''
	elog "You will need to select databases in /etc/${PN}.conf."
	elog "For details, please see the ${PN}(8) manual page."
	elog ''
	elog 'An up-to-date description of the available Sanesecurity'
	elog 'databases is available at,'
	elog ''
	elog '  http://sanesecurity.com/usage/signatures/'
	elog ''
}

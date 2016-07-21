# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Downloads and installs third-party clamav signatures"
HOMEPAGE="http://sourceforge.net/projects/unofficial-sigs"
SRC_URI="mirror://sourceforge/unofficial-sigs/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
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
	# First, fix the paths contained in the configuration file. Eventually
	# these should be moved under /run, but for now we keep them sync'ed
	# with the default clamd.conf.
	local pid_default="/var/run/clamd.pid"
	local pid_gentoo="/var/run/clamav/clamd.pid"

	# clamd listens on a local socket by default. The clamd_socket
	# setting needs to be uncommented in the configuration file for it
	# to take effect.
	local socket_default="#clamd_socket=\"/var/run/clamd.socket\""
	local socket_gentoo="clamd_socket=\"/var/run/clamav/clamd.sock\""

	sed -i  -e '$a\pkg_mgr="emerge"' \
		-e "\$a\\pkg_rm=\"emerge -C ${PN}\"" \
		-e "s~${socket_default}~${socket_gentoo}~" \
		-e "s~${pid_default}~${pid_gentoo}~" \
		"${PN}.conf" \
		|| die "failed to update paths in the ${PN}.conf file"

	# Now, change the script's working directory to point to
	# /var/lib/${PN}. We'll need to make this writable by the clamav
	# user during src_install.
	sed -i  -e "s~/usr/unofficial-dbs~/var/lib/${PN}~" "${PN}.conf" \
		|| die "failed to update the work_dir variable in ${PN}.conf"

	# Tell the script that it's been configured.
	local cfged_default='user_configuration_complete="no"'
	local cfged_gentoo='user_configuration_complete="yes"'
	sed -i "s/${cfged_default}/${cfged_gentoo}/" "${PN}.conf" \
		|| die "failed to set user configuration completed in ${PN}.conf"
}

src_install() {
	dosbin "${PN}.sh"

	# We set the script's working directory to /var/lib/${PN} in
	# src_compile, so make sure that the permissions are set correctly
	# here. By default, it runs as clamav/clamav.
	diropts -m 0755 -o clamav -g clamav
	dodir "/var/lib/${PN}"

	insinto /etc/logrotate.d
	doins "${PN}-logrotate"

	insinto /etc
	doins "${PN}.conf"

	doman "${PN}.8"
	dodoc CHANGELOG INSTALL README
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

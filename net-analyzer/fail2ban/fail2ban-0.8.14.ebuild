# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/fail2ban/fail2ban-0.8.14.ebuild,v 1.3 2015/04/08 18:01:21 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=yes

inherit distutils-r1 systemd vcs-snapshot

DESCRIPTION="scans log files and bans IPs that show malicious signs"
HOMEPAGE="http://www.fail2ban.org/"
SRC_URI="https://github.com/${PN}/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="selinux"

DEPEND=""
RDEPEND="net-misc/whois
	virtual/mta
	virtual/logger
	net-firewall/iptables
	selinux? ( sec-policy/selinux-fail2ban )"

src_prepare() {
	sed -i -e 's|/var\(/run/fail2ban\)|\1|g' $( find . -type f ) || die
}

src_test() {
	./${PN}-testcases-all
}

DOCS=( ChangeLog DEVELOP README.md THANKS TODO doc/run-rootless.txt )

src_install() {
	distutils-r1_src_install

	rm -rf "${D}"/usr/share/doc/${PN}

	# not FILESDIR
	newconfd files/gentoo-confd ${PN}
	newinitd files/gentoo-initd ${PN}
	systemd_dounit files/${PN}.service
	systemd_dotmpfilesd files/${PN}-tmpfiles.conf
	doman man/*.{1,5}

	# Use INSTALL_MASK  if you do not want to touch /etc/logrotate.d.
	# See http://thread.gmane.org/gmane.linux.gentoo.devel/35675
	insinto /etc/logrotate.d
	newins files/${PN}-logrotate ${PN}
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-0.7"
	previous_less_than_0_7=$?
}

pkg_postinst() {
	if [[ $previous_less_than_0_7 = 0 ]] ; then
		elog
		elog "Configuration files are now in /etc/fail2ban/"
		elog "You probably have to manually update your configuration"
		elog "files before restarting Fail2ban!"
		elog
		elog "Fail2ban is not installed under /usr/lib anymore. The"
		elog "new location is under /usr/share."
		elog
		elog "You are upgrading from version 0.6.x, please see:"
		elog "http://www.fail2ban.org/wiki/index.php/HOWTO_Upgrade_from_0.6_to_0.8"
	fi
	if ! has_version ${CATEGORY}/${PN} && \
		! has_version dev-python/pyinotify && ! has_version app-admin/gamin; then
		elog "For most jail.conf configurations, it is recommended you install either"
		elog "dev-python/pyinotify or app-admin/gamin (in order of preference)"
		elog "to control how log file modifications are detected"
	fi
}

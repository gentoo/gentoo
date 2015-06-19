# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/fail2ban/fail2ban-99999999.ebuild,v 1.5 2015/05/05 19:08:19 jer Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 git-r3 systemd vcs-snapshot

DESCRIPTION="scans log files and bans IPs that show malicious signs"
HOMEPAGE="http://www.fail2ban.org/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="selinux systemd"

DEPEND=""
RDEPEND="
	net-firewall/iptables
	net-misc/whois
	virtual/logger
	virtual/mta
	selinux? ( sec-policy/selinux-fail2ban )
	systemd? ( $(python_gen_cond_dep 'sys-apps/systemd[python,${PYTHON_USEDEP}]' 'python*' ) )
"

DOCS=( ChangeLog DEVELOP README.md THANKS TODO doc/run-rootless.txt )

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	# Replace /var/run with /run, but not in the top source directory
	sed -i -e 's|/var\(/run/fail2ban\)|\1|g' $( find . -type f -mindepth 2 ) || die

	distutils-r1_src_prepare
}

python_test() {
	${EPYTHON} bin/${PN}-testcases
}

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
	if ! has_version ${CATEGORY}/${PN}; then
		if ! has_version dev-python/pyinotify && ! has_version app-admin/gamin; then
			elog "For most jail.conf configurations, it is recommended you install either"
			elog "dev-python/pyinotify or app-admin/gamin (in order of preference)"
			elog "to control how log file modifications are detected"
		fi
		if ! has_version dev-lang/python[sqlite]; then
			elog "If you want to use ${PN}'s persistent database, then reinstall"
			elog "dev-lang/python with USE=sqlite"
		fi

		if has_version sys-apps/systemd[-python]; then
			elog "If you want to track logins through sys-apps/systemd's"
			elog "journal backend, then reinstall sys-apps/systemd with USE=python"
		fi
	fi
}

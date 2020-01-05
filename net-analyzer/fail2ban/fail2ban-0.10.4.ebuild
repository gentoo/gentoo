# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 eutils systemd vcs-snapshot

DESCRIPTION="scans log files and bans IPs that show malicious signs"
HOMEPAGE="https://www.fail2ban.org/"
SRC_URI="https://github.com/${PN}/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sparc x86"
IUSE="selinux systemd"

# TODO support ipfw and ipfilter
RDEPEND="
	kernel_linux? ( net-firewall/iptables )
	kernel_FreeBSD? ( sys-freebsd/freebsd-pf )
	net-misc/whois
	virtual/logger
	virtual/mta
	selinux? ( sec-policy/selinux-fail2ban )
	systemd? ( $(python_gen_cond_dep '|| (
		dev-python/python-systemd[${PYTHON_USEDEP}]
		sys-apps/systemd[python(-),${PYTHON_USEDEP}]
	)' 'python*' ) )
"

RESTRICT="test"
DOCS=( ChangeLog DEVELOP README.md THANKS TODO doc/run-rootless.txt )

python_prepare_all() {
	eapply_user

	# Replace /var/run with /run, but not in the top source directory
	find . -mindepth 2 -type f -exec \
		sed -i -e 's|/var\(/run/fail2ban\)|\1|g' {} + || die

	sed -i -e 's|runscript|openrc-run|g' files/gentoo-initd || die

	distutils-r1_python_prepare_all
}

python_compile() {
	if python_is_python3; then
		./fail2ban-2to3 || die
	fi
	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all

	rm -rf "${D}"/usr/share/doc/${PN} "${D}"/run || die

	# not FILESDIR
	newconfd files/gentoo-confd ${PN}
	newinitd files/gentoo-initd ${PN}
	sed -e "s:@BINDIR@:${EPREFIX}/usr/bin:g" files/${PN}.service.in > "${T}/${PN}.service" || die
	systemd_dounit "${T}/${PN}.service"
	systemd_dotmpfilesd files/${PN}-tmpfiles.conf
	doman man/*.{1,5}

	# Use INSTALL_MASK  if you do not want to touch /etc/logrotate.d.
	# See http://thread.gmane.org/gmane.linux.gentoo.devel/35675
	insinto /etc/logrotate.d
	newins files/${PN}-logrotate ${PN}

	keepdir /var/lib/${PN}
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
}

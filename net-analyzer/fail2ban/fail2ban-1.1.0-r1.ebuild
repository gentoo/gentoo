# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{10..13} )

inherit bash-completion-r1 distutils-r1 systemd tmpfiles

DESCRIPTION="Scans log files and bans IPs that show malicious signs"
HOMEPAGE="https://www.fail2ban.org/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/fail2ban/fail2ban"
	inherit git-r3
else
	SRC_URI="https://github.com/fail2ban/fail2ban/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="selinux systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pyasyncore[${PYTHON_USEDEP}]
		dev-python/pyasynchat[${PYTHON_USEDEP}]
	' 3.12)
	virtual/logger
	virtual/mta
	selinux? ( sec-policy/selinux-fail2ban )
	systemd? (
		$(python_gen_cond_dep '
			dev-python/python-systemd[${PYTHON_USEDEP}]
		')
	)
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/aiosmtpd[${PYTHON_USEDEP}]
		')
	)
"

DOCS=( ChangeLog DEVELOP README.md THANKS TODO doc/run-rootless.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.2-adjust-apache-logs-paths.patch
	"${FILESDIR}"/${PN}-1.0.2-umask-tests.patch
	"${FILESDIR}"/${PN}-1.1.0-openssh-9.8.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Replace /var/run with /run, but not in the top source directory
	find . -mindepth 2 -type f -exec \
		sed -i -e 's|/var\(/run/fail2ban\)|\1|g' {} + || die
}

python_test() {
	# Skip testRepairDb for bug #907348 (didn't always fail..)
	# https://github.com/fail2ban/fail2ban/issues/3586
	bin/fail2ban-testcases \
		--no-network \
		--ignore databasetestcase.DatabaseTest.testRepairDb \
		--verbosity=4 || die "Tests failed with ${EPYTHON}"

	# Workaround for bug #790251
	rm -rf fail2ban.egg-info || die
}

python_install_all() {
	distutils-r1_python_install_all

	rm -rf "${ED}"/usr/share/doc/${PN} "${ED}"/run || die

	newconfd files/fail2ban-openrc.conf ${PN}

	# These two are placed in the ${BUILD_DIR} after being "built"
	# in install_scripts().
	newinitd "${BUILD_DIR}/fail2ban-openrc.init" "${PN}"
	systemd_dounit "${BUILD_DIR}/${PN}.service"

	dotmpfiles files/${PN}-tmpfiles.conf

	doman man/*.{1,5}

	# Use INSTALL_MASK if you do not want to touch /etc/logrotate.d.
	# See http://thread.gmane.org/gmane.linux.gentoo.devel/35675
	insinto /etc/logrotate.d
	newins files/${PN}-logrotate ${PN}

	keepdir /var/lib/${PN}

	newbashcomp files/bash-completion ${PN}-client
	bashcomp_alias ${PN}-client ${PN}-server ${PN}-regex
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-0.7"
	previous_less_than_0_7=$?
}

pkg_postinst() {
	tmpfiles_process ${PN}-tmpfiles.conf

	if [[ ${previous_less_than_0_7} == 0 ]] ; then
		elog
		elog "Configuration files are now in /etc/fail2ban/"
		elog "You probably have to manually update your configuration"
		elog "files before restarting Fail2Ban!"
		elog
		elog "Fail2Ban is not installed under /usr/lib anymore. The"
		elog "new location is under /usr/share."
		elog
		elog "You are upgrading from version 0.6.x, please see:"
		elog "http://www.fail2ban.org/wiki/index.php/HOWTO_Upgrade_from_0.6_to_0.8"
	fi

	if ! has_version dev-python/pyinotify ; then
		elog "For most jail.conf configurations, it is recommended you install"
		elog "dev-python/pyinotify to control how log file modifications are detected"
	fi

	if ! has_version dev-lang/python[sqlite] ; then
		elog "If you want to use ${PN}'s persistent database, then reinstall"
		elog "dev-lang/python with USE=sqlite. If you do not use the"
		elog "persistent database feature, then you should set"
		elog "dbfile = :memory: in fail2ban.conf accordingly."
	fi
}

# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Nagios Plugin to check hdds, ssds and NVMe drives using SMART"
HOMEPAGE="https://www.claudiokuenzler.com/monitoring-plugins/check_smart.php"
SRC_URI="https://github.com/Napsty/check_smart/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/nagios
	acct-user/nagios
	sys-apps/smartmontools
	virtual/perl-Getopt-Long
"
S="${WORKDIR}/check_smart-${PV}"

src_install() {
	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe check_smart.pl

	dodoc README.md
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "This plugin needs to run as root, otherwise you're not able to lauch smartctl correctly. You have two options:"
		elog "	1. Launch the plugin itself as root with sudo"
		elog "	2. Lauch the plugin as Nagios user and the smartctl command as root with sudo"
		elog "Entry in sudoers (of course adapt your paths if necessary):"
		elog "nagios   ALL = NOPASSWD: /usr/$(get_libdir)/nagios/plugins/check_smart.pl    # for option 1"
		elog "nagios   ALL = NOPASSWD: /usr/sbin/smartctl                  # for option 2"
	fi
}

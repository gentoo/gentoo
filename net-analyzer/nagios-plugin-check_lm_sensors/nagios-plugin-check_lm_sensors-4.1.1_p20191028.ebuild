# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module vcs-snapshot

MY_PN="${PN/nagios-plugin-/}"
MY_COMMIT="80db8aa58be8f5d7800564d62305281be1ec8e6b"

DESCRIPTION="Nagios plugin to monitor the values of onboard sensors and disk temperatures"
HOMEPAGE="https://github.com/matteocorti/check_lm_sensors"
SRC_URI="https://github.com/matteocorti/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-perl/Module-Install"
RDEPEND="
	dev-perl/JSON-MaybeXS
	dev-perl/Monitoring-Plugin
	virtual/perl-Getopt-Long
"

src_compile() {
	default
	pod2man ${MY_PN}.pod > ${MY_PN}.1 || die
}

src_install() {
	perl-module_src_install
	doman ${MY_PN}.1
	local plugindir="/usr/$(get_libdir)/nagios/plugins"
	dodir "${plugindir}"
	mv "${ED}/usr/bin/${MY_PN}" "${ED}/${plugindir}" || die
}

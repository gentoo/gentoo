# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-check_rbl/nagios-check_rbl-1.3.7.ebuild,v 1.2 2015/02/02 14:43:14 jer Exp $

EAPI=5

inherit multilib

DESCRIPTION="check_rbl is a Nagios plugin that fails if a host is blacklisted"
HOMEPAGE="https://svn.id.ethz.ch/projects/nagios_plugins/wiki/check_rbl"

MY_P="${P/nagios-/}"

SRC_URI="https://svn.id.ethz.ch/projects/nagios_plugins/downloads/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~hppa"
IUSE=""

# The package's INSTALL/Makefile.PL files specify its dependencies.
#
#   * Data::Validate::Domain (dev-perl/Data-Validate-Domain)
#   * Data::Validate::IP (dev-perl/Data-Validate-IP)
#   * IO::Select (dev-lang/perl)
#   * Monitoring::Plugin (dev-perl/Monitoring-Plugin)
#   * Monitoring::Plugin::Getopt (dev-perl/Monitoring-Plugin)
#   * Monitoring::Plugin::Threshold (dev-perl/Monitoring-Plugin)
#   * Net::DNS (dev-perl/Net-DNS)
#   * Readonly (dev-perl/Readonly)
#
RDEPEND="dev-lang/perl
	dev-perl/Data-Validate-Domain
	dev-perl/Data-Validate-IP
	dev-perl/Monitoring-Plugin
	dev-perl/Net-DNS
	dev-perl/Readonly"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	perl Makefile.PL INSTALLDIRS=vendor || die
}

src_install() {
	default

	local nagiosplugindir=/usr/$(get_libdir)/nagios/plugins
	# move this aftertime as it's a bit strange otherwise
	dodir "${nagiosplugindir}"
	mv "${D}"/usr/bin/check_rbl "${D}"/"${nagiosplugindir}" || die
}

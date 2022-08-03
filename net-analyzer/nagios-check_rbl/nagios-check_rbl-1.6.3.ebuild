# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Monitor whether or not a host is blacklisted"
HOMEPAGE="https://github.com/matteocorti/check_rbl"

MY_P="${P/nagios-/}"
SRC_URI="https://github.com/matteocorti/check_rbl/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~hppa sparc ~x86"
IUSE=""

# No, this is not redundant -- see bug 627082.
RESTRICT=test

# The package's INSTALL/Makefile.PL files specify its dependencies.
#
#   * Data::Validate::Domain (dev-perl/Data-Validate-Domain)
#   * Data::Validate::IP (dev-perl/Data-Validate-IP)
#   * IO::Select (dev-lang/perl)
#   * Monitoring::Plugin (dev-perl/Monitoring-Plugin)
#   * Monitoring::Plugin::Getopt (dev-perl/Monitoring-Plugin)
#   * Monitoring::Plugin::Threshold (dev-perl/Monitoring-Plugin)
#   * Net::DNS (dev-perl/Net-DNS)
#   * Net::IP (dev-perl/Net-IP)
#   * Readonly (dev-perl/Readonly)
#   * Socket (virtual/perl-Socket)
#
RDEPEND="dev-lang/perl
	dev-perl/Data-Validate-Domain
	dev-perl/Data-Validate-IP
	dev-perl/Monitoring-Plugin
	dev-perl/Net-DNS
	dev-perl/Net-IP
	dev-perl/Readonly
	virtual/perl-Socket"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	perl Makefile.PL INSTALLDIRS=vendor || die
}

src_install() {
	default

	local nagiosplugindir=/usr/$(get_libdir)/nagios/plugins

	# It's simplest to move this file after it's been installed.
	dodir "${nagiosplugindir}"
	mv "${D}"/usr/bin/check_rbl "${D}"/"${nagiosplugindir}" || die
}

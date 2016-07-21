# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Needed for perl_rm_files in src_prepare() only.
inherit perl-functions

DESCRIPTION="Monitor whether or not a host is blacklisted"
HOMEPAGE="https://github.com/matteocorti/check_rbl"

MY_P="${P/nagios-/}"

# We rename the tarball here because the upstream source changed without
# a new release. That change happens to fix bug #583966, so we do want
# the newer tarball. But I think, without the rename, that user might
# have gotten a checksum failure.
SRC_URI="${HOMEPAGE}/releases/download/v${PV}/${MY_P}.tar.gz
	-> ${MY_P}-r1.tar.gz"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~hppa ~x86"
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

src_prepare() {
	default

	# The copy of version.pm that upstream ships causes problems and
	# isn't necessary. They probably shouldn't be shipping it at all.
	# See bug #583966 for more information. You should check on
	# https://github.com/matteocorti/check_rbl/issues/6 every once
	# in a while to see if this can be removed.
	perl_rm_files inc/version.pm
}

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

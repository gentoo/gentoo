# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-check_rbl/nagios-check_rbl-1.3.0.ebuild,v 1.5 2014/05/26 12:04:36 jer Exp $

EAPI=4

inherit multilib

DESCRIPTION="check_rbl is a Nagios plugin that fails if a host is blacklisted"
HOMEPAGE="https://svn.id.ethz.ch/projects/nagios_plugins/wiki/check_rbl"

MY_P="${P/nagios-/}"

SRC_URI="https://svn.id.ethz.ch/projects/nagios_plugins/downloads/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="amd64 hppa x86"
IUSE=""

# The Makefile.PL looks for Nagios::Plugin::Getopt and
# Nagios::Plugin::Threshold, but I believe these are provided by
# dev-perl/Nagios-Plugins.
RDEPEND="dev-lang/perl
	dev-perl/Nagios-Plugin
	dev-perl/Net-DNS
	dev-perl/Readonly"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

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

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

MY_PN="${PN#nagios-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A nagios plugin for checking MySQL server health"
HOMEPAGE="https://labs.consol.de/nagios/${MY_PN}/"
SRC_URI="https://labs.consol.de/assets/downloads/nagios/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Found by grepping for "use " in the built
# plugins-scripts/check_mysql_health.
RDEPEND="dev-perl/DBD-mysql
	dev-perl/DBI
	virtual/perl-Data-Dumper
	virtual/perl-File-Temp
	virtual/perl-Net-Ping
	virtual/perl-Time-HiRes"

S="${WORKDIR}/${MY_P}"

src_configure(){
	# Should match net-analyzer/{monitoring,nagios}-plugins.
	econf --libexecdir="/usr/$(get_libdir)/nagios/plugins"
}

# Here we should have a pkg_preinst() that creates the nagios user/group
# (using the same command from e.g. net-analyzer/nagios-plugins). But
# right now, the build system for check_mysql_health has a bug: it
# doesn't use the configured user (INSTALL_OPTIONS aren't passed to
# /usr/bin/install), so it's pointless. Don't forget to inherit
# user.eclass!

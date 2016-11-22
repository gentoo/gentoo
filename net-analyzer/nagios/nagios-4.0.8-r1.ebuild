# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The Nagios metapackage"
HOMEPAGE="http://www.nagios.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="~net-analyzer/nagios-core-${PV}
	|| ( net-analyzer/nagios-plugins net-analyzer/monitoring-plugins )
	!net-analyzer/nagios-imagepack"

pkg_postrm() {
	elog "Note: this is a meta package for ${PN}."
	elog "To remove it completely, or before re-emerging,"
	elog "use emerge --depclean."
}

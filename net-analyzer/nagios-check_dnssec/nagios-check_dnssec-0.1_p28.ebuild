# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=${P/nagios-/}

DESCRIPTION="check_dnssec is a set of Nagios plugins to monitor DNSSEC services"
HOMEPAGE="https://svn.durchmesser.ch/trac/check_dnssec"
# No upstream tarballs, tagged releaess in SVN only.
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	|| (
		net-analyzer/nagios-plugins
		net-analyzer/monitoring-plugins
	)
	net-libs/ldns"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A nagios plugin for checking logfiles"
HOMEPAGE="https://labs.consol.de/nagios/check_logfiles/index.html"

MY_P=${P/nagios-/}

SRC_URI="https://labs.consol.de/assets/downloads/nagios/${MY_P}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND="|| ( >=net-analyzer/nagios-plugins-1.4.13-r1 >=net-analyzer/monitoring-plugins-2 )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--libexecdir="${EPREFIX}/usr/$(get_libdir)/nagios/plugins" \
		--sysconfdir="${EPREFIX}/etc/nagios"
}

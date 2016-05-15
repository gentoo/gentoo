# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A nagios plugin for checking logfiles"
HOMEPAGE="https://labs.consol.de/nagios/check_logfiles/index.html"

MY_P=${P/nagios-/}

SRC_URI="https://labs.consol.de/assets/downloads/nagios/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=net-analyzer/nagios-plugins-1.4.13-r1"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--prefix=/usr \
		--sysconfdir=/etc/nagios
}

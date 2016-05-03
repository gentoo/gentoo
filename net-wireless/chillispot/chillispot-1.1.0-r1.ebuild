# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="open source captive portal or wireless LAN access point controller"
HOMEPAGE="http://www.chillispot.info/"
SRC_URI="http://www.chillispot.info/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc s390 sh ~sparc x86"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND=""

src_prepare() {
	chmod 644 doc/*.conf
	find . -exec chmod go-w '{}' \;

	eapply "${FILESDIR}"/${P}-gcc44.patch

	default
}

src_install() {
	emake DESTDIR="${D}" STRIPPROG=true install
	cd doc && dodoc chilli.conf freeradius.users hotspotlogin.cgi firewall.iptables

	# init script provided by Michele Beltrame bug #124698
	doinitd "${FILESDIR}"/${PN}
}

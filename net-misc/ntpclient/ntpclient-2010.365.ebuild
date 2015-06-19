# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ntpclient/ntpclient-2010.365.ebuild,v 1.4 2014/08/10 20:45:38 slyfox Exp $

EAPI=4
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A NTP (RFC-1305) client for unix-alike computers"
HOMEPAGE="http://doolittle.icarus.com/ntpclient/"
SRC_URI="http://doolittle.icarus.com/${PN}/${PN}_${PV/./_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE=""

#S="${WORKDIR}/${PN}-2010"

src_unpack() {
	default
	mv "${WORKDIR}"/${PN}* ${P} || die
}

src_prepare() {
	sed -i -e 's/-O2//;s/LDFLAGS +=/LDLIBS +=/' Makefile || die
	tc-export CC
}

src_install() {
	dobin ntpclient
	dodoc README HOWTO rate.awk rate2.awk
}

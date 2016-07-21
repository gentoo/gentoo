# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

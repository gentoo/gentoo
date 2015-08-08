# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="ephemeris files for optional extended accuracy of astrolog's calculations"
HOMEPAGE="http://www.astrolog.org/astrolog.htm"
SRC_URI="http://www.astrolog.org/ftp/ephem/ephemall.zip"

LICENSE="astrolog"
SLOT="0"
# works fine on x86 - runs probably on other architectures, too
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

S="${WORKDIR}"

RDEPEND="app-misc/astrolog"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_install() {
	dodir /usr/share/astrolog
	cp * "${D}"/usr/share/astrolog || die "cp failed"
}

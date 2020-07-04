# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
BDEPEND="app-arch/unzip"

src_install() {
	insinto /usr/share/astrolog
	doins -r .
}

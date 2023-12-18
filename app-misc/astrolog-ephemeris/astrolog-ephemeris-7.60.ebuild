# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with app-misc/astrolog

DESCRIPTION="ephemeris files for optional extended accuracy of astrolog's calculations"
HOMEPAGE="https://www.astrolog.org/astrolog.htm"
SRC_URI="https://www.astrolog.org/ftp/ephem/ephemall.zip"

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

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit webapp eutils
WEBAPP_MANUAL_SLOT="yes"

DESCRIPTION="Simple webapp to monitor the status of mirrors"
# The author has passed away: https://www.apache.org/memorials/henk_penning.html
HOMEPAGE="http://www2.projects.science.uu.nl/csg/mirmon/mirmon.html"
SRC_URI="https://deb.debian.org/debian/pool/main/m/${PN}/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.8.5-r2:0"
RDEPEND="${DEPEND}
	dev-perl/File-Tempdir
	dev-perl/Socket6"

PATCHES=(
	"${FILESDIR}/2.11-Add-ipv6-monitor-support-to-mirmon.patch"
	"${FILESDIR}/2.11-Fix-options.patch"
)

src_install() {
	# Don't install empty dirs
	MY_CGIBINDIR=""
	MY_ICONSDIR=""
	MY_ERRORSDIR=""

	webapp_src_preinst

	for file in mirmon.html mirmon.txt; do
		dodoc ${file}
		rm -f ${file}
	done
	cp -R icons "${D}"/${MY_HTDOCSDIR}
	rm -rf icons
	cp -R . "${D}"/${MY_HOSTROOTDIR}

	webapp_src_install
}

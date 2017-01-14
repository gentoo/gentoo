# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Dynamic DNS client with plugins for several dynamic dns services"
HOMEPAGE="https://savannah.nongnu.org/projects/updatedd/"
SRC_URI="https://savannah.nongnu.org/download/updatedd/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${P}-options.patch"
	"${FILESDIR}/fix-ovh-DYNDNSHOST.patch"
	"${FILESDIR}/respect-docdir.patch"
)

src_configure() {
	econf --disable-static --docdir="/usr/share/doc/${PF}"
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Contribution database for the m17n library"
HOMEPAGE="https://savannah.nongnu.org/projects/m17n"
SRC_URI="http://download.savannah.gnu.org/releases/m17n/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="~dev-db/m17n-db-1.6.4"

src_configure() {
	# force the script not to test for m17n presence, trust Portage
	# dependency handling.
	export HAVE_M17N_DB=yes

	econf
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README
}

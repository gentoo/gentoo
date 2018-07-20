# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="'Dive Into Python' by Mark Pilgrim - Python 3"
HOMEPAGE="http://www.diveintopython3.net/"

SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz
	pdf? (
		https://dev.gentoo.org/~monsieurp/packages/${P}-pdf.tar.gz
	)"

LICENSE="CC-BY-SA-3.0"
SLOT="3"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="pdf"

src_install() {
	insinto "/usr/share/doc/${PN}-${SLOT}"
	use pdf && dodoc "${P}.pdf"
	doins -r *
}

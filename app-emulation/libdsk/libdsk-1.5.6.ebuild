# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="LIBDSK is a library for accessing discs and disc image files"
HOMEPAGE="http://www.seasip.info/Unix/LibDsk/"
SRC_URI="http://www.seasip.info/Unix/LibDsk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

src_prepare() {
	eapply "${FILESDIR}"/${P}-include-sysmacros.patch
	eapply_user
}

src_install() {
	emake DESTDIR="${D}" install
	DOCS="doc/${PN}.txt doc/${PN}.pdf" einstalldocs
}

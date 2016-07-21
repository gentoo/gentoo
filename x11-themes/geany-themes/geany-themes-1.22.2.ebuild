# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="A collection of colour schemes for Geany"
HOMEPAGE="https://github.com/codebrainz/geany-themes"
SRC_URI="mirror://github/codebrainz/${PN}/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-2.1 BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-util/geany-${PV:0:4}"

src_install() {
	insinto /usr/share/geany
	doins -r colorschemes

	dodoc AUTHORS ChangeLog README.md
}

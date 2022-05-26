# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A collection of colour schemes for Geany"
HOMEPAGE="https://github.com/codebrainz/geany-themes"
SRC_URI="https://github.com/downloads/codebrainz/${PN}/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-2.1 BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-util/geany-${PV:0:4}"

src_install() {
	default
	insinto /usr/share/geany
	doins -r colorschemes
}

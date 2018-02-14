# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A utility to create text art tables from delimited input"
HOMEPAGE="https://sourceforge.net/projects/tabler/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README
}

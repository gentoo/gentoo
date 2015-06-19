# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/physlock/physlock-0.4.3.ebuild,v 1.2 2013/08/17 01:03:08 blueness Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="lightweight Linux console locking tool"
HOMEPAGE="https://github.com/muennich/physlock"
SRC_URI="mirror://github/muennich/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_prepare() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Bandwidth Monitor NG is a small and simple console-based bandwidth monitor"
SRC_URI="http://www.gropp.org/bwm-ng/${P}.tar.gz"
HOMEPAGE="http://www.gropp.org/"

KEYWORDS="amd64 ~arm ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="html csv"

DEPEND=">=sys-libs/ncurses-5.4-r4
	>=sys-apps/net-tools-1.60-r1"

RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog INSTALL NEWS README THANKS )

src_configure() {
	econf \
		--with-ncurses \
		--with-procnetdev \
		$(use_enable html) \
		$(use_enable csv)
}

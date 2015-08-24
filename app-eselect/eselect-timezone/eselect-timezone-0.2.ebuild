# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Manages timezone selection"
HOMEPAGE="https://www.gentoo.org"
SRC_URI="https://dev.gentoo.org/~ottxor/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_install() {
	insinto /usr/share/eselect/modules
	doins timezone.eselect
}

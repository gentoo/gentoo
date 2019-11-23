# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="open-cobol"
# Future proof pkg if maintainer or p-m want to bump to latest GNUCobol

DESCRIPTION="an open-source COBOL compiler"
HOMEPAGE="https://sourceforge.net/projects/open-cobol/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
# License must be changed to GPL-3+ if/when pkgmove is done
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="berkdb nls readline"

RDEPEND="dev-libs/gmp:0=
	berkdb? ( sys-libs/db:4.8= )
	sys-libs/ncurses
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	sys-devel/libtool"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf \
		$(use_with berkdb db) \
		$(use_enable nls) \
		$(use_with readline)
	default
}

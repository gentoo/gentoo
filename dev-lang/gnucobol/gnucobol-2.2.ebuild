# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An open-source COBOL compiler"
HOMEPAGE="https://open-cobol.sourceforge.io"
SRC_URI="mirror://sourceforge/open-cobol/${P}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb nls"

BDEPEND="nls? ( sys-devel/gettext )"
RDEPEND="dev-libs/gmp:0
	sys-libs/ncurses:0"
DEPEND="${RDEPEND}
	${BDEPEND}
	berkdb? ( sys-libs/db:4.8 )"

PATCHES=(
	"${FILESDIR}/${PN}-2.2-disable-data-hooks.patch"
)

src_configure() {
	econf \
		$(use_with berkdb db) \
		$(use_enable nls)
}

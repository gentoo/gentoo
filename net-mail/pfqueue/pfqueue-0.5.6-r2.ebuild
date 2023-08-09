# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="pfqueue is an ncurses console-based tool for managing Postfix queued messages"
HOMEPAGE="http://pfqueue.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

BDEPEND="sys-devel/libtool"
RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

DOCS=( README ChangeLog NEWS TODO AUTHORS )

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${PN}-0.5.6-clang16-build-fix.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

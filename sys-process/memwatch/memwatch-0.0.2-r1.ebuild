# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Interactive memory viewer"
HOMEPAGE="https://bitbucket.org/PascalRD/memwatch/"
SRC_URI="http://unixdev.ru/src/${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	einfo "Regenerating autotools files..."
	./autogen.sh || die "autogen failed"
}

src_configure() {
	econf
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}

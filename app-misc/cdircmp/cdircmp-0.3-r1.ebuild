# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdircmp/cdircmp-0.3-r1.ebuild,v 1.4 2012/10/06 16:59:30 armin76 Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Compare directories and select files to copy"
HOMEPAGE="http://home.hccnet.nl/paul.schuurmans/"
SRC_URI="http://home.hccnet.nl/paul.schuurmans/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.4"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_prepare() {
	sed -i Makefile \
		-e 's| -o | $(LDFLAGS)&|g' \
		|| die "sed Makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dodoc AUTHORS ChangeLog README

	dobin ${PN} || die "dobin failed"
}

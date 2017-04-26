# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Small shell utility, similar to expect(1)"
HOMEPAGE="http://empty.sourceforge.net"
SRC_URI="mirror://sourceforge/empty/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="virtual/logger"

src_prepare() {
	eapply "${FILESDIR}/${PN}-respect-LDFLAGS.patch"
	eapply_user
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin empty
	doman empty.1
	dodoc README
	dodoc -r examples
}

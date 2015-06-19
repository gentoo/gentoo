# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fblogo/fblogo-0.5.2.ebuild,v 1.12 2010/09/30 10:32:18 spock Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Creates images to substitute Linux boot logo"
#HOMEPAGE="http://freakzone.net/gordon/#fblogo"
HOMEPAGE="http://www.gentoo.org/"
#SRC_URI="http://freakzone.net/gordon/src/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm ppc ~sparc x86"
IUSE=""

RDEPEND="media-libs/libpng
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/fblogo-0.5.2-cross.patch

	sed -i -e '/-o fblogo/d' \
		-e 's:LIBS:LDLIBS:' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README CHANGES
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils font toolchain-funcs

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="http://unifoundry.com/"
SRC_URI="http://unifoundry.com/pub/debian/${P}.tar.gz"

LICENSE="czyborra GPL-2 GPL-3 GPL-2-with-font-exception public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" install || die

	font_xfont_config
	font_fontconfig

	dodoc README unifont-intro.txt
}

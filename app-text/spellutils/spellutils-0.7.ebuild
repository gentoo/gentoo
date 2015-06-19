# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/spellutils/spellutils-0.7.ebuild,v 1.13 2013/07/24 02:46:56 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="spellutils includes 'newsbody' (useful for spellchecking in mails, etc.)"
HOMEPAGE="http://home.worldonline.dk/byrial/spellutils/"
SRC_URI="http://home.worldonline.dk/byrial/spellutils/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc alpha ~mips ~hppa amd64"
IUSE="nls"

DEPEND="
	nls? ( sys-devel/gettext )
"
DEPEND="
	nls? ( virtual/libintl )
"

DOCS=( NEWS README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-nls.patch
}

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

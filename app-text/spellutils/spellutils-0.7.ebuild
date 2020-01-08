# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="spellutils includes 'newsbody' (useful for spellchecking in mails, etc.)"
HOMEPAGE="http://home.worldonline.dk/byrial/spellutils/"
SRC_URI="http://home.worldonline.dk/byrial/spellutils/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~mips ppc ~sparc x86"
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

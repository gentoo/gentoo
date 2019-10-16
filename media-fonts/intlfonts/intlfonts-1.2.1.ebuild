# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit font

IUSE="bdf"

DESCRIPTION="International X11 fixed fonts"
HOMEPAGE="https://www.gnu.org/directory/intlfonts.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"

DEPEND="x11-apps/bdftopcf
		>=x11-apps/mkfontscale-1.2.0"
RDEPEND=""

src_compile() {
	econf --with-fontdir=/usr/share/fonts/${PN}
}

src_install() {
	emake install fontdir="${D}/usr/share/fonts/${PN}" || die
	find "${D}/usr/share/fonts/${PN}" -name '*.pcf' | xargs gzip -9
	use bdf || rm -rf "${D}/usr/share/fonts/${PN}/bdf"
	dodoc ChangeLog NEWS README
	dodoc Emacs.ap
	font_xfont_config
}

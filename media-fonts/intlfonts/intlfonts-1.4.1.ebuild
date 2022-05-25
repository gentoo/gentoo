# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="International X11 fixed fonts"
HOMEPAGE="https://www.gnu.org/directory/intlfonts.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="public-domain HPND GPL-3+-with-font-exception"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="bdf"

BDEPEND="x11-apps/bdftopcf
	>=x11-apps/mkfontscale-1.2.0"

DOCS=( ChangeLog NEWS README Emacs.ap )

src_configure() {
	econf \
		--with-fontdir=/usr/share/fonts/${PN} \
		--enable-compress="gzip -9" \
		$(use_with bdf)
}

src_install() {
	emake install fontdir="${ED}/usr/share/fonts/${PN}"
	einstalldocs
	font_xfont_config
}

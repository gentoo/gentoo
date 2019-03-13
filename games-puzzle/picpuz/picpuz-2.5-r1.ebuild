# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2-utils

DESCRIPTION="A jigsaw puzzle program"
HOMEPAGE="http://kornelix.squarespace.com/picpuz/"
SRC_URI="http://kornelix.squarespace.com/storage/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-pthread-underlinking.patch
)

src_compile() {
	emake \
		BINDIR="/usr/bin" \
		DATADIR=/usr/share/${PN} \
		DOCDIR=/usr/share/doc/${PF}/html
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r icons locales
	doicon -s 48 icons/${PN}.png
	make_desktop_entry ${PN} Picpuz
	HTML_DOCS="doc/userguide-en.html doc/images" einstalldocs
	dodoc doc/{changelog,README,translations}
	newman doc/${PN}.man ${PN}.1
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

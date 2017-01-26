# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2-utils

DESCRIPTION="D&D character generator"
HOMEPAGE="http://pcgen.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcgen/${P}-full.zip"

LICENSE="LGPL-2.1 OGL-1.0a"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}

src_prepare() {
	default

	rm -vf *.bat || die
	sed "/dirname/ c\cd \"\/usr\/share\/${PN}\"" pcgen.sh > "${T}"/${PN} || die
}

src_install() {
	dobin "${T}"/${PN}
	insinto /usr/share/${PN}
	doins -r *
	newicon -s 128 system/sponsors/pcgen/pcgen_128x128.png ${PN}.png
	make_desktop_entry ${PN} PCGen
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

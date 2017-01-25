# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 gnome2-utils xdg
DESCRIPTION="Mathematics software for geometry"
HOMEPAGE="https://www.geogebra.org"
SRC_URI=""
EGIT_REPO_URI="https://github.com/geogebra/geogebra.git"
EGIT_CLONE_TYPE="shallow"
KEYWORDS=""
LICENSE="CC-BY-NC-SA-3.0 GPL-3"
SLOT="0"
RESTRICT="mirror"
IUSE=""
DEPEND="dev-java/oracle-jdk-bin[javafx]
	>=dev-java/gradle-bin-3.0"
# Requires oracle-jdk/jre-bin because there is no openjfx ebuild as of now
RDEPEND="|| (
		dev-java/oracle-jre-bin[javafx]
		dev-java/oracle-jdk-bin[javafx]
	)"

src_compile() {
	gradle :desktop:installDist
}

src_install() {
	local destdir="/opt/${PN}"
	insinto $destdir
	doins -r desktop/build/install/desktop/lib/
	exeinto $destdir/bin
	doexe desktop/build/install/desktop/bin/desktop
	dosym $destdir/bin/desktop /usr/bin/geogebra
	make_desktop_entry geogebra Geogebra "geogebra" Science
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}

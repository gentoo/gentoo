# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lxmed/lxmed-20120515.ebuild,v 1.1 2012/06/06 16:33:16 ssuominen Exp $

EAPI=4
inherit eutils gnome2-utils java-utils-2

DESCRIPTION="freedesktop.org specification compatible menu editor"
HOMEPAGE="http://lxmed.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	x11-libs/gksu"
DEPEND=""

S=${WORKDIR}/${PN}/content

src_prepare() {
	sed -i -e '/^Icon/s:=.*:=lxmed:' lxmed.desktop || die
}

src_install() {
	java-pkg_dojar LXMenuEditor.jar
	java-pkg_dolauncher lxmed --jar LXMenuEditor.jar

	insinto /usr/share/icons/hicolor/48x48/apps
	doins lxmed.png

	domenu lxmed.desktop
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }

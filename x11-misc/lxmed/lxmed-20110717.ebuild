# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils java-utils-2

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
	doicon lxmed.png
	domenu lxmed.desktop
}

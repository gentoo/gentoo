# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/touchfreeze/touchfreeze-0.2.5-r1.ebuild,v 1.5 2013/03/02 23:54:00 hwoarang Exp $

EAPI=4

inherit eutils qt4-r2

DESCRIPTION="X11 touch pad driver configuration utility"
HOMEPAGE="http://kde-apps.org/content/show.php/TouchFreeze?content=61442"
SRC_URI="http://www.fit.vutbr.cz/~kombrink/personal/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="x11-libs/libX11
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}
	x11-drivers/xf86-input-synaptics
"

PATCHES=(
	"${FILESDIR}"/${P}-underlinking.patch
)

src_install() {
	dobin ${PN}
	newicon res/touchpad.svg ${PN}.svg
	dodoc AUTHORS README
	make_desktop_entry ${PN} TouchFreeze ${PN} 'Qt;System'
}

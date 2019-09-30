# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="An open source clone of the Asus launcher for EeePC"
HOMEPAGE="https://wiki.lxde.org/en/LXLauncher"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2
	gnome-base/gnome-menus
	x11-libs/startup-notification"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	lxde-base/menu-cache
	!lxde-base/lxlauncher-gmenu"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README
}

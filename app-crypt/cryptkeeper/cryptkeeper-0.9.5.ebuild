# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit base eutils gnome2

DESCRIPTION="EncFS system tray applet for GNOME"
HOMEPAGE="http://tom.noflag.org.uk/cryptkeeper.html"
SRC_URI="http://tom.noflag.org.uk/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="gnome-base/gconf:2
	>=sys-fs/encfs-1.7.2
	>=sys-fs/fuse-2.8.0
	gnome-extra/zenity"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-binutils-gold.patch"
	"${FILESDIR}/${P}-fix_cryptkeeper.desktop.patch"
	"${FILESDIR}/${P}-fix-ftbfs-gcc-4.7-672010.patch"
	"${FILESDIR}/${P}-is_mounted_overflow_fix.patch"
)

DOCS="TODO"

src_prepare() {
	base_src_prepare
	gnome2_src_prepare
}

src_configure() {
	econf $(use_enable nls)
}

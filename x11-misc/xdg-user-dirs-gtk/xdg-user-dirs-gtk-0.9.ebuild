# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnome.org

DESCRIPTION="xdg-user-dirs-gtk integrates xdg-user-dirs into the Gnome desktop and Gtk+ applications"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xdg-user-dirs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=x11-misc/xdg-user-dirs-0.14
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e '/Encoding/d' \
		-e 's:OnlyShowIn=GNOME;LXDE;Unity;:NotShowIn=KDE;:' \
		user-dirs-update-gtk.desktop.in || die
}

pkg_postinst() {
	elog
	elog " This package tries to automatically use some sensible default "
	elog " directories for your documents, music, video and other stuff. "
	elog
	elog " If you want to change those directories to your needs, see "
	elog " the settings in ~/.config/user-dir.dirs "
	elog
}

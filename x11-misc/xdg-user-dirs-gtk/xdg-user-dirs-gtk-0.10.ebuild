# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdg-user-dirs-gtk/xdg-user-dirs-gtk-0.10.ebuild,v 1.11 2015/04/18 20:38:37 pacho Exp $

EAPI=5
inherit gnome.org readme.gentoo

DESCRIPTION="xdg-user-dirs-gtk integrates xdg-user-dirs into the Gnome desktop and Gtk+ applications"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xdg-user-dirs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="
	>=x11-misc/xdg-user-dirs-0.14
	>=x11-libs/gtk+-3.5.1:3
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
"

DOC_CONTENTS="
	This package tries to automatically use some sensible default
	directories for your documents, music, video and other stuff.
	If you want to change those directories to your needs, see
	the settings in ~/.config/user-dir.dirs
"

src_prepare() {
	sed -i \
		-e '/Encoding/d' \
		-e 's:OnlyShowIn=GNOME;LXDE;Unity;:NotShowIn=KDE;:' \
		user-dirs-update-gtk.desktop.in || die
}

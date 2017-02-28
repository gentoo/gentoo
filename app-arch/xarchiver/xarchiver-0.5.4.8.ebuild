# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils xdg-utils

DESCRIPTION="A GTK+ archive manager that can be used with Thunar"
HOMEPAGE="https://github.com/ib/xarchiver"
SRC_URI="https://github.com/ib/xarchiver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-libs/glib-2:=
	x11-libs/gtk+:3="
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	sed -e '/COPYING/d' -e '/NEWS/d' -i doc/Makefile.am || die
	default
	eautoreconf
}

pkg_postinst() {
	xdg_desktop_database_update
	GNOME2_ECLASS_ICONS="usr/share/icons/hicolor" \
	gnome2_icon_cache_update

	elog "You need external programs for some formats, including:"
	elog "7zip - app-arch/p7zip"
	elog "arj - app-arch/unarj app-arch/arj"
	elog "lha - app-arch/lha"
	elog "lzop - app-arch/lzop"
	elog "rar - app-arch/unrar app-arch/rar"
	elog "zip - app-arch/unzip app-arch/zip"
}

pkg_postrm() {
	xdg_desktop_database_update
	GNOME2_ECLASS_ICONS="usr/share/icons/hicolor" \
	gnome2_icon_cache_update
}

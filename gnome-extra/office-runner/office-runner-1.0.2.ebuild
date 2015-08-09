# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 readme.gentoo

DESCRIPTION="Lighthearted tool to temporarily inhibit GNOME's suspend on lid close behavior"
HOMEPAGE="http://www.hadess.net/search/label/office-runner"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="
	dev-libs/glib:2
	>=gnome-base/gnome-settings-daemon-3.0
	>=x11-libs/gtk+-3.8:3
"
# requires systemd's org.freedesktop.login1 dbus service
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/systemd-190
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	sys-devel/gettext
"

DOC_CONTENTS="${PN} inhibits suspend on lid close only for 10 minutes"

src_install() {
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}

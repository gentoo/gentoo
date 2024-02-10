# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME2_EAUTORECONF="yes"
inherit gnome2 readme.gentoo-r1

DESCRIPTION="Lighthearted tool to temporarily inhibit GNOME's suspend on lid close behavior"
HOMEPAGE="https://www.hadess.net/search/label/office-runner"
SRC_URI="https://gitlab.gnome.org/GNOME/office-runner/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/glib:2
	>=gnome-base/gnome-settings-daemon-3.0
	>=x11-libs/gtk+-3.8:3
"
# requires systemd's org.freedesktop.login1 dbus service
RDEPEND="${DEPEND}
	>=sys-apps/systemd-190
"
BDEPEND="
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	sys-devel/gettext
"

DOC_CONTENTS="${PN} inhibits suspend on lid close only for 10 minutes"

src_install() {
	gnome2_src_install
	mv "${ED}"/usr/share/{appdata,metainfo}/ || die
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}

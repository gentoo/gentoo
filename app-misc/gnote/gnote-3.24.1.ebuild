# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 readme.gentoo-r1

DESCRIPTION="Desktop note-taking application"
HOMEPAGE="https://wiki.gnome.org/Apps/Gnote"

LICENSE="GPL-3+ FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# Automagic:
# glib-2.32 dep
# >=dev-libs/unittest++-1.5.1 (but not detected due to missing .pc)
COMMON_DEPEND="
	>=app-crypt/libsecret-0.8
	>=app-text/gtkspell-3.0:3
	>=dev-cpp/glibmm-2.32:2
	>=dev-cpp/gtkmm-3.18:3.0
	>=dev-libs/glib-2.32:2[dbus]
	>=dev-libs/libxml2-2:2
	dev-libs/libxslt
	>=sys-apps/util-linux-2.16:=
	>=x11-libs/gtk+-3.20:3
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gsettings-desktop-schemas
"
DEPEND="${DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.35.0
	dev-util/itstool
	virtual/pkgconfig
"

src_prepare() {
	# Do not alter CFLAGS
	sed 's/-DDEBUG -g/-DDEBUG/' -i configure.ac configure || die

	gnome2_src_prepare

	if has_version net-fs/wdfs; then
		DOC_CONTENTS="You have net-fs/wdfs installed. app-misc/gnote will use it to
		synchronize notes."
	else
		DOC_CONTENTS="Gnote can use net-fs/wdfs to synchronize notes.
		If you want to use that functionality just emerge net-fs/wdfs.
		Gnote will automatically detect that you did and let you use it."
	fi
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable debug)
}

src_install() {
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}

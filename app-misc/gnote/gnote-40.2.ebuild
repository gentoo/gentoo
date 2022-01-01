# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
DEPEND="
	>=app-crypt/libsecret-0.8
	>=app-text/gspell-1.6.0:=
	>=dev-cpp/glibmm-2.62.0:2
	>=dev-cpp/gtkmm-3.22.20:3.0
	>=dev-libs/glib-2.32:2[dbus]
	>=dev-libs/libxml2-2:2
	dev-libs/libxslt
	>=sys-apps/util-linux-2.16:=
	>=x11-libs/gtk+-3.22.20:3
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.35.0
	dev-util/itstool
	virtual/pkgconfig
"

PATCHES=("${FILESDIR}"/${PN}-3.38.1-cstddef.patch)

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

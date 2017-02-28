# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 virtualx

DESCRIPTION="PackageKit client for the GNOME desktop"
HOMEPAGE="https://www.freedesktop.org/software/PackageKit/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd udev" # test

# XXX: test, upstream managed to break gpk-self-test beyond repair
# gdk-pixbuf used in gpk-animated-icon
# pango used on gpk-common
RDEPEND="
	>=dev-libs/glib-2.32:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.15.3:3
	>=x11-libs/libnotify-0.7.0:=
	x11-libs/pango

	>=app-admin/packagekit-base-0.9.1
	>=media-libs/libcanberra-0.10[gtk3]
	>=sys-apps/dbus-1.1.2

	media-libs/fontconfig
	x11-libs/libX11

	systemd? ( >=sys-apps/systemd-42 )
	!systemd? ( sys-auth/consolekit )
	udev? ( virtual/libgudev:= )
"
DEPEND="${RDEPEND}
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig
"

# NOTES:
# app-text/docbook-sgml-utils required for man pages

# UPSTREAM:
# see if tests can forget about display (use eclass for that ?)

src_prepare() {
	# * disable tests with graphical dialogs and that require packagekitd
	#   to be run with the dummy backend and installed .ui files
	# * disable tests that fails every time packagekit developers make a
	#   tiny change to headers
	# * gpk_test_markdown_func: no definition for that one
	sed -e '/g_test_add_func.*gpk_test_enum_func/d' \
		-e '/g_test_add_func.*gpk_test_dbus_task_func/d' \
		-e '/g_test_add_func.*gpk_test_error_func/d' \
		-e '/g_test_add_func.*gpk_test_modal_dialog/d' \
		-e '/g_test_add_func.*gpk_test_task_func/d' \
		-e '/g_test_add_func.*gpk_test_markdown_func/d' \
		-i src/gpk-self-test.c || die

	# XXX: g_autoptr requires explicit type support
	sed -e 's/g_autoptr(GpkTask)/GpkTask */' \
		-i src/gpk-self-test.c || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--localstatedir=/var \
		--enable-iso-c \
		--disable-tests \
		$(use_enable systemd) \
		$(use_enable udev gudev)
		# $(use_enable test tests)
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx emake check
}

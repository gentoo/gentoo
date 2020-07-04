# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org meson virtualx xdg

DESCRIPTION="GNOME color profile tools"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-color-manager/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="packagekit raw test"
RESTRICT="!test? ( test )"

# Need gtk+-3.3.8 for https://bugzilla.gnome.org/show_bug.cgi?id=673331
# vte could be made optional
RDEPEND="
	>=dev-libs/glib-2.31.10:2
	>=media-libs/lcms-2.2:2
	>=media-libs/libcanberra-0.10[gtk3]
	media-libs/libexif
	media-libs/tiff:0=

	>=x11-libs/gtk+-3.3.8:3
	>=x11-libs/vte-0.25.1:2.91
	>=x11-misc/colord-1.3.1:0=
	>=x11-libs/colord-gtk-0.1.20

	packagekit? ( app-admin/packagekit-base )
	raw? ( media-gfx/exiv2:0= )
"
# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
DEPEND="${RDEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# https://bugzilla.gnome.org/show_bug.cgi?id=796428
	"${FILESDIR}"/3.28-remove-unwvanted-check.patch
)

src_prepare() {
	xdg_src_prepare

	# Fix hard-coded package name
	# https://gitlab.gnome.org/GNOME/gnome-color-manager/issues/3
	sed 's:argyllcms:media-gfx/argyllcms:' -i src/gcm-utils.h || die
}

src_configure() {
	# Always enable tests since they are check_PROGRAMS anyway
	local emesonargs=(
		$(meson_use raw exiv)
		$(meson_use packagekit)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! has_version media-gfx/argyllcms ; then
		elog "If you want to do display or scanner calibration, you will need to"
		elog "install media-gfx/argyllcms"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}

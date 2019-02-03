# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit gnome.org gnome2-utils meson python-any-r1 virtualx xdg

DESCRIPTION="Gnome install & update software"
HOMEPAGE="https://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="firmware gnome gtk-doc spell test udev"

RDEPEND="
	>=dev-libs/appstream-glib-0.7.3:0
	>=x11-libs/gdk-pixbuf-2.32.0:2
	>=dev-libs/glib-2.46:2
	>=x11-libs/gtk+-3.22.4:3
	>=dev-libs/json-glib-1.2.0
	app-crypt/libsecret
	>=net-libs/libsoup-2.52.0:2.4
	dev-db/sqlite:3
	gnome? ( >=gnome-base/gnome-desktop-3.17.92:3= )
	spell? ( app-text/gspell )
	sys-auth/polkit
	>=app-admin/packagekit-base-1.1.0
	firmware? ( >=sys-apps/fwupd-1.0.3 )
	udev? ( virtual/libgudev )
	>=gnome-base/gsettings-desktop-schemas-3.11.5
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]') )
"
# test? ( dev-util/valgrind )

python_check_deps() {
	use test && has_version "dev-util/dogtail[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	# FIXME: investigate limba support
	local emesonargs=(
		$(meson_use test enable-tests)
		$(meson_use spell enable-gspell)
		$(meson_use gnome enable-gnome-desktop)
		-Denable-man=true
		-Denable-packagekit=true
		-Denable-polkit=true
		$(meson_use firmware enable-fwupd)
		-Denable-flatpak=false
		-Denable-limba=false
		-Denable-rpm-ostree=false
		-Denable-steam=false
		$(meson_use gnome enable-shell-extensions)
		-Denable-odrs=false
		-Denable-ubuntuone=false
		-Denable-ubuntu-reviews=false
		-Denable-webapps=true
		$(meson_use udev enable-gudev)
		-Denable-snap=false
		-Denable-external-appstream=false
		-Denable-valgrind=false
		$(meson_use gtk-doc enable-gtk-doc)
	)
	meson_src_configure
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
	gnome2_icon_cache_update
}

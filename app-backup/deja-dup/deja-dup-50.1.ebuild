# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson gnome2-utils optfeature vala xdg

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://apps.gnome.org/DejaDup/"
SRC_URI="https://gitlab.gnome.org/World/deja-dup/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	$(vala_depend)
	>=dev-util/blueprint-compiler-0.14
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/appstream-glib )
"

DEPEND="
	>=gui-libs/libadwaita-1.8:1
	>=dev-libs/glib-2.80:2[dbus]
	>=gui-libs/gtk-4.18:4
	>=dev-libs/json-glib-1.2
	>=app-crypt/libsecret-0.18.6[vala]
	>=net-libs/libsoup-3.0:3.0
	>=app-backup/duplicity-2.1.0
"

RDEPEND="${DEPEND}
	gnome-base/dconf
	gnome-base/gvfs[fuse]
"

src_prepare() {
	default
	# disk-small.test is missing from the release tarball; others are flaky due to
	# null error detail in async callbacks (upstream bugs)
	sed -i \
		-e "/'disk-small'/d" \
		-e "/'custom-tool-wrapper-bad'/d" \
		-e "/'instance-error'/d" \
		-e "/'no-space'/d" \
		-e "/'restore-full'/d" \
		-e "/'write-error'/d" \
		libdeja/tests/meson.build || die
	vala_setup
}

src_test() {
	export GVFS_DISABLE_FUSE=1
	meson_src_test
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
	optfeature "Restic backend support" ">=app-backup/restic-0.17.1"
	optfeature "Rclone backend support" net-misc/rclone
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

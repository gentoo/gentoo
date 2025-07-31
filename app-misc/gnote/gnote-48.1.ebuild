# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 meson readme.gentoo-r1

DESCRIPTION="Desktop note-taking application"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnote"

LICENSE="GPL-3+ FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.74:2[dbus]
	>=dev-cpp/glibmm-2.74:2.68
	>=dev-cpp/gtkmm-4.10.0:4.0
	>=gui-libs/libadwaita-1
	>=app-crypt/libsecret-0.8
	>=dev-libs/libxml2-2:2=
	dev-libs/libxslt
	>=sys-apps/util-linux-2.16
	test? ( dev-libs/unittest++ )
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
BDEPEND="
	dev-util/itstool
	virtual/pkgconfig
"

src_prepare() {
	default

	if ! use test; then
		sed -i -e "/unit_test_pp/ s/ = .*/ = disabler()/" meson.build || die
	fi

	if has_version net-fs/wdfs; then
		DOC_CONTENTS="You have net-fs/wdfs installed. app-misc/gnote will use it to
		synchronize notes."
	else
		DOC_CONTENTS="Gnote can use net-fs/wdfs to synchronize notes.
		If you want to use that functionality just emerge net-fs/wdfs.
		Gnote will automatically detect that you did and let you use it."
	fi
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}

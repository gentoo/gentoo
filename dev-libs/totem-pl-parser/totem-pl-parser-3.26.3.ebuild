# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson xdg

DESCRIPTION="Playlist parsing library"
HOMEPAGE="https://developer.gnome.org/totem-pl-parser/stable/"

LICENSE="LGPL-2+"
SLOT="0/18"
IUSE="archive crypt gtk-doc +introspection +quvi test"
RESTRICT="!test? ( test )"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	>=dev-libs/glib-2.36:2
	quvi? ( >=media-libs/libquvi-0.9.1:0= )
	archive? ( >=app-arch/libarchive-3:0= )
	dev-libs/libxml2:2
	crypt? ( dev-libs/libgcrypt:0= )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.3 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		gnome-base/gvfs[http]
		sys-apps/dbus )
"

src_prepare() {
	# Disable tests requiring network access, bug #346127
	# 3rd test fails on upgrade, not once installed
	# Leio: I consider network tests important for ensuring full functionality, thus trying with them again */
	#sed -e 's:\(g_test_add_func.*/parser/resolution.*\):/*\1*/:' \
	#	-e 's:\(g_test_add_func.*/parser/parsing/itms_link.*\):/*\1*/:' \
	#	-e 's:\(g_test_add_func.*/parser/parsability.*\):/*\1*/:'\
	#	-i plparse/tests/parser.c || die "sed failed"

	xdg_src_prepare
}

src_configure() {
	# uninstalled-tests is abused to switch from loading live FS helper
	# to in-build-tree helper, check on upgrades this is not having other
	# consequences, bug #630242
	local emesonargs=(
		-Denable-quvi=$(usex quvi yes no)
		-Denable-libarchive=$(usex archive yes no)
		-Denable-libgcrypt=$(usex crypt yes no)
		$(meson_use gtk-doc enable-gtk-doc)
		$(meson_use introspection)
	)
	meson_src_configure
}

src_test() {
	# This is required as told by upstream in bgo#629542
	GVFS_DISABLE_FUSE=1 dbus-run-session meson test -C "${BUILD_DIR}"
}

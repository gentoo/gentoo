# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson xdg flag-o-matic

DESCRIPTION="Playlist parsing library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/totem-pl-parser"
LICENSE="LGPL-2+"

SLOT="0/18"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="archive crypt gtk-doc +introspection test +uchardet"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.56:2
	archive? ( >=app-arch/libarchive-3:0= )
	dev-libs/libxml2:2=
	crypt? ( dev-libs/libgcrypt:0= )
	uchardet? ( app-i18n/uchardet )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		gnome-base/gvfs[http]
		sys-apps/dbus
	)
"

src_prepare() {
	if has network-sandbox ${FEATURES}; then
		einfo "Skipping tests needing network access due to the FEATURE network-sandbox being enabled"
		sed -i -e "s/, 'podcast'//g" plparse/tests/meson.build || die
	fi

	default
}

src_configure() {
	# uninstalled-tests is abused to switch from loading live FS helper
	# to in-build-tree helper, check on upgrades this is not having other
	# consequences, bug #630242
	local emesonargs=(
		-Denable-libarchive=$(usex archive)
		-Denable-libgcrypt=$(usex crypt)
		-Denable-uchardet=$(usex uchardet)
		$(meson_use gtk-doc enable-gtk-doc)
		$(meson_use introspection)
	)
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version) # bug 915087
	meson_src_configure
}

src_test() {
	# This is required as told by upstream in bgo#629542
	GVFS_DISABLE_FUSE=1 dbus-run-session meson test -C "${BUILD_DIR}" --print-errorlogs || die
}

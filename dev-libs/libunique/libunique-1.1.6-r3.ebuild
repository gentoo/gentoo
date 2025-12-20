# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 virtualx

DESCRIPTION="A library for writing single instance application"
HOMEPAGE="https://wiki.gnome.org/Attic/LibUnique"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
IUSE="debug dbus +introspection"

RDEPEND="
	>=dev-libs/glib-2.12:2
	>=x11-libs/gtk+-2.11:2[introspection?]
	x11-libs/libX11
	dbus? (
		>=dev-libs/dbus-glib-0.70
		sys-apps/dbus[X]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.11
	sys-devel/gettext
	virtual/pkgconfig
"
# For eautoreconf
#	dev-build/gtk-doc-am

PATCHES=(
	# Include NUL terminator in unique_message_data_get_filename()
	"${FILESDIR}/${P}-include-terminator.patch"

	# test-unique: Resolve format string issues
	"${FILESDIR}/${P}-fix-test.patch"

	# Remove compiler warnings
	"${FILESDIR}/${P}-compiler-warnings.patch"

	# Remove G_CONST_RETURN usage, now that its gone in glib
	"${FILESDIR}/${PN}-1.1.6-G_CONST_RETURN.patch"
)

src_configure() {
	gnome2_src_configure \
		--disable-maintainer-flags \
		--enable-bacon \
		$(use_enable introspection) \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable dbus)
}

src_test() {
	cd "${S}/tests" || die
	cp "${FILESDIR}/run-tests" . || die "Unable to cp \${FILESDIR}/run-tests"
	virtx emake -f run-tests
}

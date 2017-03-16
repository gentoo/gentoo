# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 virtualx

DESCRIPTION="A library for writing single instance application"
HOMEPAGE="https://wiki.gnome.org/Attic/LibUnique"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug dbus +introspection"

RDEPEND="
	>=dev-libs/glib-2.12:2
	>=x11-libs/gtk+-2.11:2[introspection?]
	x11-libs/libX11
	dbus? (
		>=dev-libs/dbus-glib-0.70
		sys-apps/dbus[X] )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	sys-devel/gettext
	virtual/pkgconfig
"
# For eautoreconf
#	dev-util/gtk-doc-am

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
		--disable-static \
		--enable-bacon \
		$(use_enable introspection) \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable dbus)
}

src_test() {
	cd "${S}/tests"
	cp "${FILESDIR}/run-tests" . || die "Unable to cp \${FILESDIR}/run-tests"
	virtx emake -f run-tests || die "Tests failed"
}

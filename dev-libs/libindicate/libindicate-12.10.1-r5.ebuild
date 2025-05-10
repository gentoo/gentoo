# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VALA_USE_DEPEND="vapigen"

inherit autotools vala

DESCRIPTION="Library to raise flags on DBus for other components of the desktop"
HOMEPAGE="https://launchpad.net/libindicate"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"
IUSE="gtk +introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libdbusmenu[introspection?]
	dev-libs/libxml2:=
	gtk? (
		dev-libs/libdbusmenu[gtk3]
		x11-libs/gtk+:3
	)
	introspection? ( >=dev-libs/gobject-introspection-1 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/gnome-doc-utils
	dev-build/gtk-doc-am
	gnome-base/gnome-common
	virtual/pkgconfig
	$(vala_depend)
	test? ( dev-util/dbus-test-runner )
"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${PN}-12.10.1-tests-werror.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	vala_setup

	# python bindings are only for GTK+-2.x
	econf \
		$(use_enable gtk) \
		$(use_enable introspection) \
		$(use_enable test tests) \
		--disable-python \
		--disable-scrollkeeper \
		--with-gtk=3
}

src_test() {
	emake check XFAIL_TESTS="test-interests test-interests-multi test-max-indicators test-indicator-display test-indicator-display-half"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

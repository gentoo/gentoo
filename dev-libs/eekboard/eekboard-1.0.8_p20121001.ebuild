# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )
VALA_USE_DEPEND="vapigen"

inherit autotools gnome2-utils python-any-r1 vala vcs-snapshot virtualx xdg-utils

DESCRIPTION="An easy to use virtual keyboard toolkit"
HOMEPAGE="https://github.com/ueno/eekboard"
SRC_URI="https://github.com/ueno/${PN}/archive/e212262f29e022bdf7047861263ceea0c373e916.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +introspection libcanberra static-libs +vala +xtest"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="app-accessibility/at-spi2-core
	dev-libs/glib:2
	dev-libs/libcroco
	virtual/libintl
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxklavier
	x11-libs/pango
	introspection? ( dev-libs/gobject-introspection )
	libcanberra? ( media-libs/libcanberra[gtk3(+)] )
	vala? ( $(vala_depend) )
	xtest? ( x11-libs/libXtst )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-vala.patch )

src_prepare() {
	use vala && vala_src_prepare
	default
	eautoreconf
	xdg_environment_reset
}

src_configure() {
	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable libcanberra) \
		$(use_enable static-libs static) \
		$(use_enable vala) \
		$(use_enable xtest)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

src_test() {
	virtx default
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

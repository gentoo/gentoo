# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="HTTP web service mocking library"
HOMEPAGE="https://gitlab.com/uhttpmock/uhttpmock"
SRC_URI="http://tecnocode.co.uk/downloads/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"

IUSE="debug +introspection vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=net-libs/libsoup-2.37.91:2.4
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
DEPEND="${RDEPEND}
	vala? ( $(vala_depend) )
"
BDEPEND="
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable debug) \
		$(use_enable introspection) \
		$(use_enable vala)
}

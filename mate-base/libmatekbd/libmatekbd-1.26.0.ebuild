# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

DESCRIPTION="MATE keyboard configuration library"
LICENSE="GPL-2+ LGPL-2+"
SLOT="0"

IUSE="X +introspection test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.50:2
	virtual/libintl
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.24:2
	x11-libs/libX11
	>=x11-libs/libxklavier-5.2:0[introspection?]
	x11-libs/pango
	>=x11-libs/gtk+-3.22:3[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}"

BDEPEND="
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	mate_src_configure \
		$(use_with X x) \
		$(use_enable introspection) \
		$(use_enable test tests)
}

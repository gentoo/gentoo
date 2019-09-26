# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION=0.40

inherit meson vala xdg-utils

DESCRIPTION="Elementary OS library that extends GTK+"
HOMEPAGE="https://github.com/elementary/granite"
SRC_URI="https://github.com/elementary/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm x86"
# FIXME: Figure out issues with enabling doc.
# See https://github.com/gentoo/gentoo/pull/12690#issuecomment-525027164
IUSE="test"

BDEPEND="
	$(vala_depend)
	>=dev-util/meson-0.48.2
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/glib-2.50:2
	dev-libs/libgee:0.8[introspection]
	>=x11-libs/gtk+-3.22:3[introspection]
"
RDEPEND="${DEPEND}"

src_prepare() {
	vala_src_prepare
	eapply_user
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
VALA_MIN_API_VERSION="0.24"

inherit cmake-utils gnome2-utils multilib vala versionator

DESCRIPTION="A development library for elementary development"
HOMEPAGE="https://launchpad.net/granite"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/$(get_version_component_range 1-2)/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	dev-libs/gobject-introspection:=
	dev-libs/libgee:0.8[introspection]
	>=x11-libs/gtk+-3.11.6:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS )
PATCHES=(
	# https://bugs.launchpad.net/granite/+bug/1453526
	"${FILESDIR}"/${P}-build-fix{,2,3}.patch
)

src_prepare() {
	vala_src_prepare
	sed -i -e "/NAMES/s:valac:${VALAC}:" cmake/FindVala.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DLIB_INSTALL_DIR=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_install() {
	HTML_DOCS=( doc/. )
	cmake-utils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

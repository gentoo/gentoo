# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.32

inherit gnome2-utils vala cmake-utils

DESCRIPTION="Elementary OS library that extends Gtk+"
HOMEPAGE="https://github.com/elementary/granite"
SRC_URI="https://github.com/elementary/${PN}/archive/$(get_version_component_range 1-2).tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="demo nls test"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgee:0.8[introspection]
	>=x11-libs/gtk+-3.14:3[introspection]"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS COPYING )

S="${WORKDIR}"/"${PN}"-"$(get_version_component_range 1-2)"

src_prepare() {
	eapply_user

	# Disable building of the demo application (if needed)
	use demo || sed -i '/add_subdirectory (demo)/d' CMakeLists.txt

	# Disable generation of the translations (if needed)
	use nls || sed -i '/add_subdirectory (po)/d' CMakeLists.txt

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR=$(get_libdir)
		-DVALA_EXECUTABLE=${VALAC}
	)

	cmake-utils_src_configure
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

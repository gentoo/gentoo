# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake-utils gnome2-utils virtualx

DESCRIPTION="Chinese Chewing engine for IBus"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/definite/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gconf nls"

RDEPEND="app-i18n/ibus
	app-i18n/libchewing
	dev-libs/glib:2
	dev-util/gob:2
	x11-libs/gtk+:2
	x11-libs/libX11
	gconf? ( gnome-base/gconf )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/cmake-fedora
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-test.patch )
DOCS=( AUTHORS ChangeLog README.md RELEASE-NOTES.txt USER-GUIDE )

src_configure() {
	local mycmakeargs=(
		-DMANAGE_DEPENDENCY_PACKAGE_EXISTS_CMD=false
		-DPRJ_DOC_DIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	use nls || mycmakeargs+=( -DMANAGE_GETTEXT_SUPPORT=0 )
	cmake-utils_src_configure
}

src_test() {
	"${EROOT}"${GLIB_COMPILE_SCHEMAS} --allow-any-name "${BUILD_DIR}"/bin || die

	export GSETTINGS_BACKEND="memory"
	export GSETTINGS_SCHEMA_DIR="${BUILD_DIR}/bin"
	virtx cmake-utils_src_test
}

pkg_preinst() {
	use gconf && gnome2_gconf_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	use gconf && gnome2_gconf_install
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

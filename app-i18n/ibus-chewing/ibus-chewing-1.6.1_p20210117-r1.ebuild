# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake gnome2-utils vcs-snapshot virtualx

EGIT_COMMIT="8e17848d3fe3bd7de052a1c26b4161092ba1df9f"

DESCRIPTION="Chinese Chewing engine for IBus"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/definite/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~hattya/distfiles/${PN}-gob2.patch.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="app-i18n/ibus
	app-i18n/libchewing
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/libX11
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/cmake-fedora
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${WORKDIR}"/${PN}-gob2.patch
	"${FILESDIR}"/${PN}-test.patch
)
DOCS=( AUTHORS ChangeLog README.md RELEASE-NOTES.txt USER-GUIDE )

src_configure() {
	local mycmakeargs=(
		-DGCONF2_SUPPORT=OFF
		-DGSETTINGS_SUPPORT=ON
		-DMANAGE_DEPENDENCY_PACKAGE_EXISTS_CMD=false
		-DPRJ_DOC_DIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	use nls || mycmakeargs+=( -DMANAGE_GETTEXT_SUPPORT=0 )
	cmake_src_configure
}

src_test() {
	"${BROOT}"${GLIB_COMPILE_SCHEMAS} --allow-any-name "${BUILD_DIR}"/bin || die

	export GSETTINGS_BACKEND="memory"
	export GSETTINGS_SCHEMA_DIR="${BUILD_DIR}/bin"
	virtx cmake_src_test -j1
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

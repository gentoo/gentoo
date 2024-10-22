# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx xdg

DESCRIPTION="Desktop Syncing Client for Nextcloud"
HOMEPAGE="https://github.com/nextcloud/desktop"
SRC_URI="
	https://github.com/nextcloud/desktop/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/desktop-${PV/_/-}"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="doc dolphin nautilus test webengine"
RESTRICT="!test? ( test )"

# slot op for qtqui as this package uses private API parts of qtqui
# src/gui/generalsettings.cpp:#include <private/qzipwriter_p.h>
RDEPEND="
	>=dev-db/sqlite-3.34:3
	>=dev-libs/openssl-1.1.0:0=
	dev-libs/glib:2
	dev-libs/qtkeychain:=[qt6(+)]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[dbus,gui,network,sql,widgets]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtsvg:6
	dev-qt/qtwebsockets:6
	net-libs/libcloudproviders
	kde-frameworks/karchive:6
	kde-frameworks/kguiaddons:6
	sys-libs/zlib
	dolphin? (
		kde-frameworks/kcoreaddons:6
		kde-frameworks/kio:6
	)
	nautilus? ( dev-python/nautilus-python )
	webengine? ( dev-qt/qtwebengine:6[widgets] )
"
DEPEND="
	${RDEPEND}
	dev-qt/qtbase:6[concurrent,xml]
	|| ( gnome-base/librsvg media-gfx/inkscape )
	doc? (
		dev-python/sphinx
		dev-tex/latexmk
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	test? (
		dev-util/cmocka
	)
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	dolphin? ( kde-frameworks/extra-cmake-modules )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6.6-no-redefine-fortify-source.patch
	# https://github.com/nextcloud/desktop/pull/7383
	"${FILESDIR}"/${PN}-3.14.2-doc-fix.patch
)

src_prepare() {
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die
	# The image under images/building/path.png does no longer
	# exist. This is already fixed upstream and can be dropped on the
	# next bump
	sed -i '/images\/building\/path.png/d' doc/building.rst || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DBUILD_UPDATER=OFF
		$(cmake_use_find_package doc Sphinx)
		$(cmake_use_find_package doc PdfLatex)
		$(cmake_use_find_package webengine Qt6WebEngine)
		$(cmake_use_find_package webengine Qt6WebEngineWidgets)
		-DBUILD_WITH_WEBENGINE=$(usex webengine)
		-DBUILD_SHELL_INTEGRATION_DOLPHIN=$(usex dolphin)
		-DBUILD_SHELL_INTEGRATION_NAUTILUS=$(usex nautilus)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	TEST_VERBOSE=1 virtx cmake_src_test
}

src_compile() {
	local compile_targets=(all)
	if use doc; then
		compile_targets+=(doc doc-man)
	fi
	cmake_src_compile ${compile_targets[@]}
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! has_version -r "dev-libs/qtkeychain[keyring]"; then
		elog "dev-libs/qtkeychain has not been build with the 'keyring' USE flag."
		elog "Please consider enabling the 'keyring' USE flag. Otherwise you may"
		elog "have to authenticate manually every time you start the nextlcoud client."
		elog "See https://bugs.gentoo.org/912844 for more information."
	fi
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Text-based subtitles editor"
HOMEPAGE="https://subtitlecomposer.kde.org/"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE="unicode"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kross-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	media-libs/openal
	media-video/ffmpeg:0=
	unicode? ( dev-libs/icu:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-tests-optional.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PocketSphinx=ON # bug 616706
		$(cmake_use_find_package unicode ICU)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	elog "Some example scripts provided by ${PN} require dev-lang/ruby"
	elog "or dev-lang/python to be installed."
}

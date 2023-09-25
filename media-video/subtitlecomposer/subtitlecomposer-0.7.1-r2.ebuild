# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm kde.org

DESCRIPTION="Text-based subtitles editor"
HOMEPAGE="https://subtitlecomposer.kde.org/"
PATCHSET="${P}-patchset-1"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz
	https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE="unicode"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
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

PATCHES=(
	"${WORKDIR}/${PATCHSET}/${P}-tests-optional.patch"
	"${WORKDIR}/${PATCHSET}/${P}-gles-support.patch" # bug 820035
	"${WORKDIR}/${PATCHSET}/${P}-ffmpeg-5.patch" # bug 834416
	"${WORKDIR}/${PATCHSET}/${P}-replace-kross-w-qjsengine.patch" # bug 755956
	"${FILESDIR}"/${P}-ffmpeg6-{1,2}.patch # bug 910048
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PocketSphinx=ON # bug 616706
		$(cmake_use_find_package unicode ICU)
	)

	ecm_src_configure
}

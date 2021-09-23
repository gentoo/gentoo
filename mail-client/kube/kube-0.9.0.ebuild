# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.88.0
QTMIN=5.15.2
inherit ecm

DESCRIPTION="Mail client based on KDE Frameworks"
HOMEPAGE="https://kube-project.com"
SRC_URI="https://github.com/KDE/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	>=app-crypt/gpgme-1.15.1:=[cxx,qt5]
	>=dev-libs/kasync-0.3:5
	>=dev-libs/sink-0.9.0:5
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	kde-apps/kmime:5
	>=kde-frameworks/breeze-icons-${KFMIN}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-${QTMIN}:5 )
"

RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}/${P}-tests-optional.patch"
	"${FILESDIR}/${PN}-0.7.0-appdata-location.patch"
)

src_prepare() {
	ecm_src_prepare

	sed -e "/find_package.*Qt5/s/ Concurrent//" \
		-i {extensions/api,framework}/src/CMakeLists.txt || die

	if ! use test; then
		sed -e "/find_package.*Qt5/s/ Test//" \
			-i {,components/}CMakeLists.txt CMakeLists.txt \
				{extensions/api,framework}/src/CMakeLists.txt || die
		sed -e "/Qt5::Test/s/^/#DISABLED/" \
			-i {extensions/api,framework}/src/CMakeLists.txt || die
		sed -e "/set(BUILD_TESTING ON)/s/^/#DISABLED /" \
			-e "/domain\/modeltest.cpp/s/^/#DISABLED /" \
			-i framework/src/CMakeLists.txt || die
	fi

	# Failed to build (at least with gcc-11) with std c++20. Switch to std c++17
	sed -i -e "s:CMAKE_CXX_STANDARD 20:CMAKE_CXX_STANDARD 17:"\
	-e "s:c++20:c++17:" CMakeLists.txt || die "Failed switch to std c++17"
}

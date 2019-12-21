# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Mail client based on KDE Frameworks"
HOMEPAGE="https://kube-project.com"
SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	>=app-crypt/gpgme-1.7.1:=[cxx,qt5]
	dev-libs/kasync:5
	>=dev-libs/sink-0.7.0:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	kde-apps/kmime:5
	kde-frameworks/breeze-icons:5
	kde-frameworks/extra-cmake-modules:5
	kde-frameworks/kcodecs:5
	|| (
		kde-frameworks/kcontacts:5
		kde-apps/kcontacts:5
	)
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}/${P}-tests-optional.patch"
	"${FILESDIR}/${P}-require-cxx14.patch"
)

src_prepare() {
	cmake_src_prepare

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
}

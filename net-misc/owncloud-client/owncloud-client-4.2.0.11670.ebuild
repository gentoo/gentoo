# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

MY_PN="ownCloud"
REGRAPHAPI_PV="1.0.1"
DESCRIPTION="Synchronize files from ownCloud Server with your computer"
HOMEPAGE="https://owncloud.com/"
SRC_URI="https://download.owncloud.com/desktop/${MY_PN}/stable/${PV}/source/${MY_PN}-${PV}.tar.xz
	https://github.com/owncloud/libre-graph-api-cpp-qt-client/archive/refs/tags/v${REGRAPHAPI_PV}.tar.gz
		-> libregraphapi-${REGRAPHAPI_PV}.tar.gz"
S=${WORKDIR}/${MY_PN}-${PV}

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="dolphin keyring nautilus test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-db/sqlite-3.4:3
	dev-libs/qtkeychain[keyring?,qt5(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-fs/inotify-tools
	dolphin? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
	)
	nautilus? ( dev-python/nautilus-python )"

DEPEND="${RDEPEND}
	test? (
		dev-util/cmocka
		dev-qt/qttest:5
	)"

BDEPEND="
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules"

PATCHES=( "${FILESDIR}"/${PN}-3.1.0.9872-no_cmake_fetch.patch
	"${FILESDIR}"/${PN}-3.2.0.10193-no_fortify_override.patch
	)

src_prepare() {
	mv ../libre-graph-api-cpp-qt-client-${REGRAPHAPI_PV} \
		src/libsync/libregraphapisrc-src || die

	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die

	if ! use nautilus; then
		pushd shell_integration > /dev/null || die
		cmake_comment_add_subdirectory nautilus
		popd > /dev/null || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DBUILD_SHELL_INTEGRATION_DOLPHIN=$(usex dolphin)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

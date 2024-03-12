# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

MY_PN="ownCloud"
DESCRIPTION="Synchronize files from ownCloud Server with your computer"
HOMEPAGE="https://owncloud.com/"
SRC_URI="https://download.owncloud.com/desktop/${MY_PN}/stable/${PV}/source/${MY_PN}-${PV}.tar.xz"
S=${WORKDIR}/${MY_PN}-${PV}

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="keyring test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-db/sqlite-3.4:3
	dev-libs/qtkeychain[keyring?,qt6(+)]
	dev-qt/kdsingleapplication[qt6]
	dev-qt/qtbase:6[concurrent,gui,network,ssl,widgets]
	sys-fs/inotify-tools"

DEPEND="${RDEPEND}
	test? (
		dev-util/cmocka
		dev-qt/qtbase:6[test]
	)"

BDEPEND="
	dev-qt/qttools:6[linguist]
	kde-frameworks/extra-cmake-modules"

PATCHES=( "${FILESDIR}"/${PN}-3.2.0.10193-no_fortify_override.patch )

src_prepare() {
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DBUILD_TESTING=$(usex test)
		-DKDE_INSTALL_SYSCONFDIR=/etc
	)

	cmake_src_configure
}

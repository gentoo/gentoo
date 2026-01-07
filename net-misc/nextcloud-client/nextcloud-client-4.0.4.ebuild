# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic qmake-utils virtualx xdg

DESCRIPTION="Desktop Syncing Client for Nextcloud"
HOMEPAGE="https://github.com/nextcloud/desktop"
SRC_URI="
	https://github.com/nextcloud/desktop/archive/v${PV/_/-}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/desktop-${PV/_/-}"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
IUSE="dolphin nautilus test webengine"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-db/sqlite-3.34:3
	dev-libs/glib:2
	dev-libs/libp11
	>=dev-libs/openssl-1.1.0:0=
	>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
	dev-qt/qt5compat:6[qml]
	>=dev-qt/qtbase-6.8:6[dbus,gui,network,sql,sqlite,ssl,widgets]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtsvg:6
	dev-qt/qtwebsockets:6
	kde-frameworks/karchive:6
	kde-frameworks/kguiaddons:6
	net-libs/libcloudproviders
	virtual/zlib:=
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
	|| (
		gnome-base/librsvg
		media-gfx/inkscape
	)
	test? (
		dev-util/cmocka
	)
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	dolphin? ( >=kde-frameworks/extra-cmake-modules-5.106.0 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6.6-no-redefine-fortify-source.patch
)

src_prepare() {
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die

	cmake_src_prepare
}

src_configure() {
	# Temporary workaround for musl-1.2.4
	# upstream bug: https://github.com/nextcloud/desktop/issues/6536
	# gentoo bug #924503
	# XXX: This will stop working with future musl releases!
	use elibc_musl && append-cppflags -D_LARGEFILE64_SOURCE

	local mycmakeargs=(
		-DPLUGINDIR=$(qt6_get_plugindir)
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DBUILD_UPDATER=OFF
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

pkg_postinst() {
	xdg_pkg_postinst

	if ! has_version -r "dev-libs/qtkeychain[keyring]"; then
		elog "dev-libs/qtkeychain has not been build with the 'keyring' USE flag."
		elog "Please consider enabling the 'keyring' USE flag. Otherwise you may"
		elog "have to authenticate manually every time you start the nextlcoud client."
		elog "See https://bugs.gentoo.org/912844 for more information."
	fi
}

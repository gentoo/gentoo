# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream is moving tags repeatedly, then we use commit hash.
RELEASE_COMMIT="19400094df9cddc52dc46f7e5a065f1c3b20cb5c"

inherit xdg cmake

DESCRIPTION="Seafile desktop client"
HOMEPAGE="https://www.seafile.com/ https://github.com/haiwen/seafile-client/"
SRC_URI="https://github.com/haiwen/${PN}/archive/${RELEASE_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="shibboleth"

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/jansson:=
	dev-libs/openssl:=
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	shibboleth? ( dev-qt/qtwebengine:6[widgets] )
	dev-qt/qt5compat:6
	>=net-libs/libsearpc-3.2.0_p1
	~net-misc/seafile-${PV}
	sys-libs/zlib
	virtual/opengl
	elibc_musl? ( sys-libs/fts-standalone )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=(
	"${FILESDIR}/${PN}-9.0.11-select-qt6.patch"
	"${FILESDIR}/${PN}-9.0.13-QJsonValue.patch"
	"${FILESDIR}/${PN}-9.0.13-CMakeLists.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHIBBOLETH_SUPPORT="$(usex shibboleth)"
	)
	# 863554
	use elibc_musl && mycmakeargs+=( -DCMAKE_CXX_STANDARD_LIBRARIES="-lfts" )
	cmake_src_configure
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RELEASE_COMMIT="c49c317f3bf19001c06f189d0706b6a3a2d6533c"

inherit xdg cmake

DESCRIPTION="Seafile desktop client"
HOMEPAGE="https://www.seafile.com/ https://github.com/haiwen/seafile-client/"
SRC_URI="https://github.com/haiwen/${PN}/archive/${RELEASE_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="shibboleth test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/jansson
	dev-libs/libevent
	dev-libs/openssl:=
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	net-libs/libsearpc
	~net-misc/seafile-${PV}
	shibboleth? ( dev-qt/qtwebengine:5[widgets] )
	sys-libs/zlib"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )"
BDEPEND="dev-qt/linguist-tools:5"

PATCHES=(
	"${FILESDIR}/${PN}-select-qt5.patch"
	"${FILESDIR}/${PN}-7.0.9-qt-5.15.patch"
)

S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHIBBOLETH_SUPPORT="$(usex shibboleth)"
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}

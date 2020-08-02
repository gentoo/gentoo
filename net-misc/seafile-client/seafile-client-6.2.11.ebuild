# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake xdg-utils

DESCRIPTION="Seafile desktop client"
HOMEPAGE="https://github.com/haiwen/seafile-client/ https://www.seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="shibboleth test"
RESTRICT="!test? ( test )"

RDEPEND="net-libs/libsearpc
	~net-misc/seafile-${PV}
	dev-libs/libevent
	dev-libs/jansson
	dev-libs/openssl:0
	dev-db/sqlite:3
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qtdbus:5
	shibboleth? ( dev-qt/qtwebengine:5[widgets] )"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	test? ( dev-qt/qttest:5 )"

src_prepare() {
	eapply "${FILESDIR}/${PN}-select-qt5.patch"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHIBBOLETH_SUPPORT="$(usex shibboleth)"
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

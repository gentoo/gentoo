# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Seafile desktop client"
HOMEPAGE="https://github.com/haiwen/seafile-client/ http://www.seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="shibboleth test"

RDEPEND="net-libs/libsearpc
	=net-libs/ccnet-${PV}
	=net-misc/seafile-${PV}
	>=dev-libs/libevent-2.0
	>=dev-libs/jansson-2.0
	dev-libs/openssl:0=
	dev-db/sqlite:3

	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qtdbus:5
	shibboleth? ( || ( dev-qt/qtwebengine:5[widgets] dev-qt/qtwebkit:5 ) )"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	test? ( dev-qt/qttest:5 )"

src_prepare() {
	eapply "${FILESDIR}/${P}-select-qt5.patch"
	eapply "${FILESDIR}/${P}-only-use-qttest-where-needed.patch"
	cmake-utils_src_prepare
	if use shibboleth ; then
		if ! has_version "dev-qt/qtwebengine:5[widgets]" ; then
			sed -i -e 's/IF(WIN32 OR DETECTED_QT_VERSION VERSION_LESS 5.6.0)/IF(TRUE)/' CMakeLists.txt || die
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHIBBOLETH_SUPPORT="$(usex shibboleth)"
		-DBUILD_TESTING="$(usex test)"
	)
	cmake-utils_src_configure
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="forceoptional"
KFMIN=5.248.0
inherit ecm kde.org

DESCRIPTION="WS-Discovery client library based on KDSoap"
HOMEPAGE="https://invent.kde.org/libraries/kdsoap-ws-discovery-client"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="CC0-1.0 GPL-3+"
SLOT="0"
IUSE="doc"

RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6[network]
	>=net-libs/kdsoap-2.2.0[qt6]
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtbase:6[xml] )
"
BDEPEND="doc? ( app-text/doxygen[dot] )"

PATCHES=( "${FILESDIR}"/${PN}-0.2_pre20200317-no-install-docs.patch )

src_prepare() {
	ecm_src_prepare
	use test || ecm_punt_qt_module Xml
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
		-DBUILD_QCH=OFF # does not use ecm_add_qch from ECMAddQch
	)
	ecm_src_configure
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	ecm_src_install
}

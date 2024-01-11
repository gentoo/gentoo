# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=dcefb65c88e76f1f9eda8b0318006e93d15a0e1e
ECM_QTHELP="false"
ECM_TEST="true"
inherit ecm

DESCRIPTION="WS-Discovery client library based on KDSoap"
HOMEPAGE="https://invent.kde.org/libraries/kdsoap-ws-discovery-client
https://gitlab.com/caspermeijn/kdsoap-ws-discovery-client
https://caspermeijn.gitlab.io/kdsoap-ws-discovery-client"
SRC_URI="https://gitlab.com/caspermeijn/${PN}/repository/${COMMIT}/archive.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}-${COMMIT}"

LICENSE="CC0-1.0 GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc"

RESTRICT="test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	>=net-libs/kdsoap-1.9.0:=[qt5(+)]
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtxml:5 )
"
BDEPEND="doc? ( app-doc/doxygen[dot] )"

PATCHES=( "${FILESDIR}"/${PN}-0.2_pre20200317-no-install-docs.patch )

src_prepare() {
	ecm_src_prepare
	use test || ecm_punt_bogus_dep Qt5 Xml
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

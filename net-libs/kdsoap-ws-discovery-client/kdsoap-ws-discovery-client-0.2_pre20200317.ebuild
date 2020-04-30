# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="false"
ECM_TEST="forceoptional"
inherit ecm

if [[ ${PV} != *9999* ]]; then
	COMMIT=14287e92e80a77aa4c0adee2871e6b87c9c3055e
	SRC_URI="https://gitlab.com/caspermeijn/${PN}/repository/${COMMIT}/archive.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
	S="${WORKDIR}/${PN}-${COMMIT}-${COMMIT}"
else
	EGIT_REPO_URI="https://gitlab.com/caspermeijn/${PN}.git"
	inherit git-r3
fi

DESCRIPTION="WS-Discovery client library based on KDSoap"
HOMEPAGE="https://gitlab.com/caspermeijn/kdsoap-ws-discovery-client
https://caspermeijn.gitlab.io/kdsoap-ws-discovery-client"

LICENSE="CC0-1.0 GPL-3+"
SLOT="0"
IUSE="doc"

BDEPEND="
	doc? ( app-doc/doxygen[dot] )
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	>=net-libs/kdsoap-1.9.0"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtxml:5 )
"

RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}"/${P}-no-install-docs.patch
	"${FILESDIR}"/${P}-deps.patch
)

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

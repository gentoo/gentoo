# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="false"
KDE_ORG_NAME="${PN/-console/}"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm flag-o-matic kde.org

DESCRIPTION="Application console and command line interface support for KUserFeedback"
SRC_URI="mirror://kde/stable/${PN}/${KDE_ORG_NAME}-${PV}.tar.xz"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	~kde-frameworks/kuserfeedback-${PV}:5
	>=dev-qt/qtcharts-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${KDE_ORG_NAME}:6
	!<${CATEGORY}/${KDE_ORG_NAME}-1.3.0-r4:5
	>=${CATEGORY}/${KDE_ORG_NAME}-1.3.0-r4:5
"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"

ECM_REMOVE_FROM_INSTALL=(
	/usr/include/KUserFeedback
	/usr/share/qlogging-categories5
	"/usr/lib*"
)

PATCHES=( "${FILESDIR}/${KDE_ORG_NAME}-${PV}-missing-include.patch" )

src_prepare() {
	ecm_src_prepare
	sed -e "s/^ecm_install_po_files_as_qm.*/#& # disabled/" \
		-i CMakeLists.txt || die
	ecm_punt_qt_module Qml
	ecm_punt_qt_module Widgets
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CLI=ON
		-DENABLE_CONSOLE=ON
		# disable everything else
		-DENABLE_DOCS=OFF
		-DENABLE_PHP=OFF
		-DENABLE_PHP_UNIT=OFF
		-DENABLE_SURVEY_TARGET_EXPRESSIONS=OFF
	)

	# provided by kde-frameworks/kuserfeedback:5
	append-libs -lKUserFeedbackCore -lKUserFeedbackWidgets

	ecm_src_configure
}

CMAKE_SKIP_TESTS=(
	# bugs: 921359, requires virtualx
	openglinfosourcetest
)

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
inherit qt5-build

DESCRIPTION="Set of next generation Qt Quick controls for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
fi

IUSE="widgets"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtdeclarative-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	widgets? ( =dev-qt/qtwidgets-${QT5_PV}* )
"
RDEPEND="${DEPEND}
	=dev-qt/qtgraphicaleffects-${QT5_PV}*
"

PATCHES=( "${FILESDIR}/${P}-QTBUG-104983.patch" )

src_prepare() {
	qt_use_disable_mod widgets widgets \
		src/imports/platform/platform.pro

	qt5-build_src_prepare

	# workaround for 0005-Revert-...patch dropping a header
	perl ${QT5_BINDIR}/syncqt.pl -version ${PV} || die
}

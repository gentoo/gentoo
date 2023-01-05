# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt Declarative (Quick 2)"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="opengl +sql +widgets"

DEPEND="
	=dev-qt/qtbase-${PV}*[network,opengl=,sql=,widgets=]
	=dev-qt/qtshadertools-${PV}*
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(qt_feature opengl)
		$(qt_feature sql)
		$(qt_feature widgets)
	)

	qt6-build_src_configure
}

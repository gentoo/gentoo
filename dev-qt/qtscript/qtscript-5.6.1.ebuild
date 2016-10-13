# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit qt5-build

DESCRIPTION="Application scripting library for the Qt5 framework (deprecated)"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 hppa ppc ppc64 x86"
fi

IUSE="+jit scripttools"

DEPEND="
	~dev-qt/qtcore-${PV}
	scripttools? (
		~dev-qt/qtgui-${PV}
		~dev-qt/qtwidgets-${PV}
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod scripttools widgets \
		src/src.pro

	qt5-build_src_prepare
}

src_configure() {
	local myqmakeargs=(
		$(usex jit '' JAVASCRIPTCORE_JIT=no)
	)
	qt5-build_src_configure
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=cfc616978b52a396b2ef6900546f7fc086d7cab3
inherit qt5-build

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtwidgets-${PV}
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtxml-${PV} )
"

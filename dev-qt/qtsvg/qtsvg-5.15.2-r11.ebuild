# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=24128cdf8bef53eddf31a5709bbbc46293006b1c
inherit qt5-build

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
fi

IUSE=""

RDEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtwidgets-${QT5_PV}*
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	test? ( =dev-qt/qtxml-${QT5_PV}* )
"

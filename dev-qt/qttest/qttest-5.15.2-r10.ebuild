# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=a4f9e56975fa6ab4a1f63a9b34a4d77b1cfe4acd
QT5_MODULE="qtbase"
VIRTUALX_REQUIRED="test"
inherit qt5-build

DESCRIPTION="Unit testing library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE=""

RDEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
"
DEPEND="${RDEPEND}
	test? (
		=dev-qt/qtgui-${QT5_PV}*
		=dev-qt/qtxml-${QT5_PV}*
	)
"

QT5_TARGET_SUBDIRS=(
	src/testlib
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:testlib
)

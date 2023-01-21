# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
fi

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt5 module for integrating online documentation into applications"

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtsql-${QT5_PV}*[sqlite]
	=dev-qt/qtwidgets-${QT5_PV}*
"
RDEPEND="${DEPEND}"

# https://invent.kde.org/qt/qt/qttools/-/merge_requests/2
PATCHES=( "${FILESDIR}/${PN}-5.15.4-bogusdep.patch" )

QT5_TARGET_SUBDIRS=(
	src/assistant/help
	src/assistant/qcollectiongenerator
	src/assistant/qhelpgenerator
)

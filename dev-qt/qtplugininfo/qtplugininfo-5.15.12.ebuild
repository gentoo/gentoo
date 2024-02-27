# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~x86"
fi

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt5 plugin metadata dumper"

IUSE=""

DEPEND="=dev-qt/qtcore-${QT5_PV}*"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qtplugininfo
)

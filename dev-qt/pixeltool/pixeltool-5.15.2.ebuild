# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt screen magnifier"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm arm64 ~hppa ~ppc64 ~sparc ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}:5=
	~dev-qt/qtgui-${PV}:5=
	~dev-qt/qtwidgets-${PV}
"
RDEPEND="${DEPEND}
	dev-qt/qtchooser
"

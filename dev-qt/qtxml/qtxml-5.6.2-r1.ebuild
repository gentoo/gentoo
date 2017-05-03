# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
QT5_MODULE_EXAMPLES_SUBDIRS=("examples/xml")
inherit qt5-build

DESCRIPTION="Implementation of SAX and DOM for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}
"
DEPEND="${RDEPEND}
	examples? (
		~dev-qt/qtwidgets-${PV}
		~dev-qt/qtnetwork-${PV}
	)
	test? ( ~dev-qt/qtnetwork-${PV} )
"

QT5_TARGET_SUBDIRS=(
	src/xml
)

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE_EXAMPLES_SUBDIRS=("examples")
inherit qt5-build

DESCRIPTION="XPath, XQuery, XSLT, and XML Schema validation library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtnetwork-${PV}
	examples? ( ~dev-qt/qtwidgets-${PV} )
"
RDEPEND="${DEPEND}"

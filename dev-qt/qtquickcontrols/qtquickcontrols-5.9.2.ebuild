# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Set of controls used in conjunction with Qt Quick to build complete interfaces"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="examples +widgets"
REQUIRED_USE="examples? ( widgets )"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	widgets? ( ~dev-qt/qtwidgets-${PV} )
	examples? (
		~dev-qt/qtnetwork-${PV}
		~dev-qt/qtsql-${PV}
	)
"
RDEPEND="${DEPEND}"

QT5_EXAMPLES_SUBDIRS=(
	examples
)

src_prepare() {
	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/controls/Private/private.pri \
		tests/auto/activeFocusOnTab/activeFocusOnTab.pro \
		tests/auto/controls/controls.pro \
		tests/auto/testplugin/testplugin.pro

	qt5-build_src_prepare
}

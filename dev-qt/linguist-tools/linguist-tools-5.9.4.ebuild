# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Tools for working with Qt translation data files"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ~ppc64 x86 ~amd64-fbsd"
fi

IUSE="qml"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtxml-${PV}
	qml? ( ~dev-qt/qtdeclarative-${PV} )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/linguist
)

src_prepare() {
	sed -i -e '/SUBDIRS += linguist/d' \
		src/linguist/linguist.pro || die

	qt_use_disable_mod qml qmldevtools-private \
		src/linguist/lupdate/lupdate.pro

	qt5-build_src_prepare
}

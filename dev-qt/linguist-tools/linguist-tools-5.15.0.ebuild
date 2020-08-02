# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Tools for working with Qt translation data files"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="qml"

DEPEND="
	~dev-qt/qtcore-${PV}:5=
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

src_configure() {
	# Most of qttools require files that are only generated when qmake is
	# run in the root directory.
	# Related bugs: 633776, 676948, and 716514.
	mkdir -p "${QT5_BUILD_DIR}" || die
	qt5_qmake "${QT_BUILD_DIR}"
	cp "${S}"/qttools-config.pri "${QT5_BUILD_DIR}" || die
	qt5-build_src_configure
}

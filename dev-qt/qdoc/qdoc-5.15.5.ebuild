# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt documentation generator"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

IUSE="qml"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	sys-devel/clang:=
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qdoc
)

src_prepare() {
	qt_use_disable_mod qml qmldevtools-private \
		src/qdoc/qdoc.pro

	qt5-build_src_prepare
}

src_configure() {
	# qt5_tools_configure() not enough here, needs another fix, bug 676948
	mkdir -p "${QT5_BUILD_DIR}"/src/qdoc || die
	qt5_qmake "${QT5_BUILD_DIR}"
	cp src/qdoc/qtqdoc-config.pri "${QT5_BUILD_DIR}"/src/qdoc || die

	qt5-build_src_configure
}

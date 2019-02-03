# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt documentation generator"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~ppc64 x86"
fi

IUSE="qml"

DEPEND="
	~dev-qt/qtcore-${PV}
	sys-devel/clang:=
	qml? ( ~dev-qt/qtdeclarative-${PV} )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qdoc
)

src_prepare() {
	qt_use_disable_mod qml qmldevtools-private \
		src/qdoc/qdoc.pro

	export LLVM_INSTALL_DIR="$(llvm-config --prefix)"
	# this is normally loaded in qttools.pro, so skipped by using
	# QT_TARGET_SUBDIRS causing build to fail
	sed -e '1iload(qt_find_clang)\' -i src/qdoc/qdoc.pro || die

	qt5-build_src_prepare
}

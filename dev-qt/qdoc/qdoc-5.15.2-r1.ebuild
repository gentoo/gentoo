# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt documentation generator"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

IUSE="qml"

RDEPEND="
	~dev-qt/qtcore-${PV}:5=
	sys-devel/clang:=
	qml? ( ~dev-qt/qtdeclarative-${PV} )
"
# TODO: we know it is bogus, figure out how to disable checks, bug 802492
DEPEND="${RDEPEND}
	~dev-qt/qtxml-${PV}
"

src_prepare() {
	qt_use_disable_mod qml qmldevtools-private \
		src/qdoc/qdoc.pro

	qt5-build_src_prepare
}

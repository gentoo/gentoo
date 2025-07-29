# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_EXAMPLES="true"
ECM_QTHELP="false"
ECM_TEST="true"
QTMIN=6.7.2
inherit ecm frameworks.kde.org toolchain-funcs

DESCRIPTION="Lightweight user interface framework for mobile and convergent applications"
HOMEPAGE="https://community.kde.org/Kirigami"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="openmp"

# requires package to already be installed
RESTRICT="test"

# slot op: Uses Qt6::GuiPrivate for qguiapplication_p.h
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,gui,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
"
RDEPEND="${DEPEND}
	examples? (
		!${CATEGORY}/${PN}:5[examples(-)]
		>=dev-qt/qt5compat-${QTMIN}:6[qml]
	)
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

PATCHES=(
	"${FILESDIR}"/kirigami-6.16.0-sw.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
		$(cmake_use_find_package openmp OpenMP)
	)

	ecm_src_configure
}

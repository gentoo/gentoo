# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=5.15.5
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for syntax highlighting"

LICENSE="MIT"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/perl
	>=dev-qt/linguist-tools-${QTMIN}:5
"

src_install() {
	ecm_src_install
	dobin "${BUILD_DIR}"/bin/katehighlightingindexer
}

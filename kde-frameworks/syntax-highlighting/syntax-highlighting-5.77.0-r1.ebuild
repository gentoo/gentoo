# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
QTMIN=5.15.1
inherit ecm kde.org

DESCRIPTION="Framework for syntax highlighting"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${P}-bash-zsh-fixes.patch.xz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="nls"

BDEPEND="
	dev-lang/perl
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${WORKDIR}"/${P}-bash-zsh-fixes.patch )

src_install() {
	ecm_src_install
	dobin "${BUILD_DIR}"/bin/katehighlightingindexer
}

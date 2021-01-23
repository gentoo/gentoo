# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
QTMIN=5.15.1
inherit ecm kde.org

DESCRIPTION="Framework for syntax highlighting"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PN}-5.77.0-bash-zsh-fixes.tar.xz"

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

PATCHES=(
	"${WORKDIR}/${PN}-5.77.0-bash-zsh-fixes"/0010-Bash-fix-5-at-the-end-of-a-double-quoted-string.patch
	"${WORKDIR}/${PN}-5.77.0-bash-zsh-fixes"/0011-Bash-fix-in-xy-and-more-Parameter-Expansion-Operator.patch
	"${WORKDIR}/${PN}-5.77.0-bash-zsh-fixes"/0012-Bash-Zsh-fix-cmd-in-a-case.patch
)

src_install() {
	ecm_src_install
	dobin "${BUILD_DIR}"/bin/katehighlightingindexer
}

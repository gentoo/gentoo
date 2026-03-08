# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PYTHON_COMPAT=( python3_{11..14} )
QTMIN=6.10.1
inherit ecm frameworks.kde.org python-any-r1

DESCRIPTION="Framework for syntax highlighting"

LICENSE="MIT"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# examples: dev-qt/qtbase[printsupport,widgets]
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
"
DEPEND="${RDEPEND}
	dev-libs/xerces-c
"
BDEPEND="${PYTHON_DEPS}
	dev-lang/perl
	>=dev-qt/qttools-${QTMIN}:6[linguist]
"

src_configure() {
	local mycmakeargs=(
		-DPython_EXECUTABLE="${PYTHON}"
	)
	ecm_src_configure
}

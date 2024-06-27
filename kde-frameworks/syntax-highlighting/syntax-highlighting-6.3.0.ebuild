# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for syntax highlighting"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm64"
IUSE=""

# examples: dev-qt/qtbase[printsupport,widgets]
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
"
DEPEND="${RDEPEND}
	dev-libs/xerces-c
"
BDEPEND="
	dev-lang/perl
	>=dev-qt/qttools-${QTMIN}:6[linguist]
"

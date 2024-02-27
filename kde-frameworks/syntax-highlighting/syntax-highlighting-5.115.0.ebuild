# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for syntax highlighting"

LICENSE="MIT"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
"
DEPEND="${RDEPEND}
	>=dev-qt/qtxmlpatterns-${QTMIN}:5"
BDEPEND="
	dev-lang/perl
	>=dev-qt/linguist-tools-${QTMIN}:5
"

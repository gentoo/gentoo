# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KDE_ORG_CATEGORY="kdevelop"
KFMIN=6.9.0
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

DESCRIPTION="LL(1) parser generator used mainly by KDevelop language plugins"
HOMEPAGE="https://www.kdevelop.org/"

LICENSE="LGPL-2+ LGPL-2.1+"
SLOT="0"
IUSE=""

RDEPEND="!${CATEGORY}/${PN}:6"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

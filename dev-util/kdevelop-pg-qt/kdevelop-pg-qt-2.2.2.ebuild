# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
inherit ecm kde.org

DESCRIPTION="LL(1) parser generator used mainly by KDevelop language plugins"
HOMEPAGE="https://www.kdevelop.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
"

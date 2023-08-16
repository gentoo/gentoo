# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_QTHELP="false"
inherit ecm frameworks.kde.org

DESCRIPTION="ECMAScipt compatible parser and engine"
LICENSE="BSD-2 LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv"
IUSE=""

BDEPEND="
	dev-lang/perl
"
DEPEND="
	dev-libs/libpcre
"
RDEPEND="${DEPEND}"

DOCS=( src/README )

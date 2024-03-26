# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_QTHELP="false"
inherit ecm frameworks.kde.org

DESCRIPTION="ECMAScipt compatible parser and engine"
LICENSE="BSD-2 LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

BDEPEND="
	dev-lang/perl
"
DEPEND="
	dev-libs/libpcre
"
RDEPEND="${DEPEND}"

DOCS=( src/README )

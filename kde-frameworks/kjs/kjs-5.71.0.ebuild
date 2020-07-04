# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_QTHELP="false"
inherit ecm kde.org

DESCRIPTION="ECMAScipt compatible parser and engine"
LICENSE="BSD-2 LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

BDEPEND="
	dev-lang/perl
"
DEPEND="
	dev-libs/libpcre
"
RDEPEND="${DEPEND}"

DOCS=( src/README )

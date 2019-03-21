# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_QTHELP="false"
inherit kde5

DESCRIPTION="ECMAScipt compatible parser and engine"
LICENSE="BSD-2 LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

BDEPEND="
	dev-lang/perl
"
DEPEND="
	dev-libs/libpcre
"
RDEPEND="${DEPEND}"

DOCS=( src/README )

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="ECMAScipt compatible parser and engine"
LICENSE="BSD-2 LGPL-2+"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/libpcre
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kdoctools)
	dev-lang/perl
"

DOCS=( src/README )

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kjs/kjs-5.10.0.ebuild,v 1.1 2015/05/09 10:36:08 mrueg Exp $

EAPI=5

inherit kde5

DESCRIPTION="ECMAScipt compatible parser and engine"
LICENSE="BSD-2 LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/libpcre
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kdoctools)
	dev-lang/perl
"

DOCS=( src/README )

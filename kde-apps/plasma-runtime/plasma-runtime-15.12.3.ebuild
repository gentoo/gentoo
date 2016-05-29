# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kde-runtime"
KMMODULE="plasma"
DECLARATIVE_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="Script engine and package tool for plasma"
KEYWORDS=" amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kactivities '' 4.13)
"
RDEPEND="${DEPEND}"

RESTRICT=test
# bug 443748

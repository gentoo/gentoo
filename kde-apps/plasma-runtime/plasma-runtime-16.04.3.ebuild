# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kde-runtime"
KMMODULE="plasma"
DECLARATIVE_REQUIRED="always"
WEBKIT_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="Script engine and package tool for plasma"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

DEPEND="
	kde-frameworks/kactivities:4
"
RDEPEND="${DEPEND}"

# bug 443748
RESTRICT=test

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="Open Collaboration Services provider management"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

DEPEND="
	dev-libs/libattica
"
RDEPEND="${DEPEND}"

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils

DESCRIPTION="Utilities for SAS management protocol (SMP)"
HOMEPAGE="http://sg.danny.cz/sg/smp_utils.html"
MY_PV="${PV/_beta/b}"
MY_PV="${MY_PV/_p/r}"
MY_P="${PN}-${MY_PV}"
SRC_URI="http://sg.danny.cz/sg/p/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog COVERAGE CREDITS README )

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${PN}-0.98-sysmacros.patch #580258
)

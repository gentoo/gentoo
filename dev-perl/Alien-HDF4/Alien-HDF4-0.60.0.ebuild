# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=0.06
DIST_AUTHOR=ETJ
inherit perl-module

DESCRIPTION="Encapsulate install info for HDF4"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

RDEPEND="
	sci-libs/hdf
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.402.0
	dev-perl/IO-All
"

PATCHES=( "${FILESDIR}/${PN}-0.50.0-shared.patch" )

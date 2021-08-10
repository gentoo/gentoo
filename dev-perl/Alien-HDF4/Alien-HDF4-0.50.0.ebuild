# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=0.05
DIST_AUTHOR=ETJ
inherit perl-module

DESCRIPTION="Encapsulate install info for HDF4"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-libs/hdf
"

DEPEND="${RDEPEND}
"

BDEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.402.0
	dev-perl/IO-All
"

PATCHES=( "${FILESDIR}/${P}-shared.patch" )

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A utility to create text art tables from delimited input"
HOMEPAGE="https://sourceforge.net/projects/tabler/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
)
DOCS=(
	AUTHORS ChangeLog README
)

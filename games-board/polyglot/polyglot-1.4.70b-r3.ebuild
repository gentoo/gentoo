# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Protocol adapter to run UCI chess engines under xboard"
HOMEPAGE="http://hardy.uhasselt.be/Toga/"
# not entirely clear what the "b" in the version stands for
SRC_URI="http://hardy.uhasselt.be/Toga/${PN}-release/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-no-common.patch
	"${FILESDIR}"/${P}-musl.patch
)
DOCS="AUTHORS ChangeLog TODO" # README* installed by build system

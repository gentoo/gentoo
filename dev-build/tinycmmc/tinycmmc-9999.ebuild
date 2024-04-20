# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Grumbel/${PN}.git"
else
	SRC_URI="https://github.com/Grumbel/${PN}/archive/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Tiny CMake Module Collections"
HOMEPAGE="https://github.com/Grumbel/tinycmmc"

LICENSE="ZLIB"
SLOT="0"

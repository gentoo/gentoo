# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=c278588e34e535f0bb8f00df3880d26928038cad

DESCRIPTION="ONNXIFI with Facebook Extension"
HOMEPAGE="https://github.com/houseroad/foxi/"
SRC_URI="https://github.com/houseroad/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # No test available

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

CommitId=bb1473a4b38b18268e8693044afdb8635bc8351b

DESCRIPTION="provides a tensor-aware channel"
HOMEPAGE="https://github.com/pytorch/tensorpipe/"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT=test

RDEPEND="
	dev-libs/libuv
"
DEPEND="${RDEPEND}
	dev-libs/libnop
"
BDEPEND=""

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

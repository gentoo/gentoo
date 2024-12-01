# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="standalone <error.h> implementation intended for musl"
HOMEPAGE="https://hacktivis.me/git/error-standalone/"
SRC_URI="https://hacktivis.me/releases/error-standalone/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="!sys-libs/glibc"

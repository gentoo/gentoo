# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Find minimal and canonical images in permutation groups"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

BDEPEND="test? (
	dev-gap/atlasrep
	dev-gap/io
)"

gap-pkg_enable_tests

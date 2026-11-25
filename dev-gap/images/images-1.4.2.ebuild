# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Find minimal and canonical images in permutation groups"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

# Temporary, https://github.com/gap-packages/images/issues/41
RESTRICT="test"

BDEPEND="test? (
	dev-gap/atlasrep
	dev-gap/io
)"

RDEPEND="dev-gap/datastructures
	dev-gap/digraphs"

gap-pkg_enable_tests

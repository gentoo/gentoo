# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Overwrite files with iterative patterns"
HOMEPAGE="https://github.com/chaos/scrub"
SRC_URI="https://github.com/chaos/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv ~sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-implicit-function-declaration-test.patch
	"${FILESDIR}"/${PN}-2.6.1-bashism-tests.patch
)

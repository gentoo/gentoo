# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Measures the speed of stdin/stdout communication"
HOMEPAGE="https://www.habets.pp.se/synscan/programs_pipebench.html"
SRC_URI="https://www.habets.pp.se/synscan/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86 ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${PN}-0.40-fix-build-system.patch
	"${FILESDIR}"/${PN}-0.40-fix-build-clang16.patch
)

src_configure() {
	append-cflags -Wall -w -pedantic
	tc-export CC
}

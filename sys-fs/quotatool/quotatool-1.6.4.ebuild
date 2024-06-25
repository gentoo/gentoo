# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Command-line utility for filesystem quotas"
HOMEPAGE="https://quotatool.ekenberg.se/"
#SRC_URI="https://quotatool.ekenberg.se/${P}.tar.gz"
SRC_URI="https://github.com/ekenberg/quotatool/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc x86"

RDEPEND="sys-fs/quota"

src_configure() {
	tc-export CC
	default
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="tools for ATA over Ethernet (AoE) network storage protocol"
HOMEPAGE="https://github.com/OpenAoE/aoetools"
SRC_URI="https://github.com/OpenAoE/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${P}"

DOCS=( NEWS README )

PATCHES=(
	"${FILESDIR}"/${PN}-32-build.patch
)

src_prepare() {
	default
	tc-export CC
}

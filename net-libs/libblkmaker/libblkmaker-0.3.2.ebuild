# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="C implementation of getblocktemplate (BIP 22)"
HOMEPAGE="https://github.com/bitcoin/libblkmaker"
LICENSE="MIT"

SRC_URI="https://gitorious.org/bitcoin/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ~ppc64 x86"
IUSE=""

DEPEND="
	>=dev-libs/jansson-2.0.0
"
RDEPEND="${DEPEND}
	!<net-misc/bfgminer-3.0.3
"

S="${WORKDIR}/bitcoin-libblkmaker/"

src_prepare() {
	./autogen.sh || die
}

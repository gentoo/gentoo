# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="IP Stack Integrity Checker"
HOMEPAGE="https://isic.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/isic/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="net-libs/libnet:1.1"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-configure.patch"
)

src_prepare() {
	default
	# Add two missing includes
	echo "#include <netinet/udp.h>" >> isic.h || die
	echo "#include <netinet/tcp.h>" >> isic.h || die

}

src_configure() {
	tc-export CC

	econf
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="https://otr.cypherpunks.ca"
SRC_URI="https://otr.cypherpunks.ca/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error:0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.1.1-fix-build-with-libgcrypt-1.10.patch"
)

src_install() {
	default
	dodoc UPGRADING

	# no static archives, #465686
	find "${ED}" -name '*.la' -delete || die
}

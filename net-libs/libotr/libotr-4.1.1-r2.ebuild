# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="https://otr.cypherpunks.ca"
SRC_URI="https://otr.cypherpunks.ca/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error:=
"
DEPEND="${RDEPEND}"
# autoconf-archive for F_S patch
BDEPEND="dev-build/autoconf-archive"

PATCHES=(
	"${FILESDIR}/${PN}-4.1.1-fix-build-with-libgcrypt-1.10.patch"
	"${FILESDIR}/${PN}-4.1.1-dont-clobber-fortify-source.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc UPGRADING

	# no static archives, #465686
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="https://otr.cypherpunks.ca"
SRC_URI="https://otr.cypherpunks.ca/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error:0="
DEPEND="${RDEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	dodoc UPGRADING

	# no static archives, #465686
	find "${D}" -name '*.la' -delete || die
}

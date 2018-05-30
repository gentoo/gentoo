# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="interface to the new Yahoo! Messenger protocol"
HOMEPAGE="http://libyahoo2.sourceforge.net/"
SRC_URI="mirror://sourceforge/libyahoo2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libressl ssl static-libs"

RDEPEND="dev-libs/glib:2
	ssl? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( dev-libs/openssl:0= )
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-asneeded.patch"
)

src_prepare() {
	default
	sed -i -e 's:-ansi -pedantic::' configure.ac || die #240912
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable ssl sample-client)
}

src_install() {
	default

	if use ssl; then
		dobin src/.libs/{autoresponder,yahoo}
	fi

	dodoc doc/*.txt

	find "${D}" -name '*.la' -delete || die "Pruning failed"
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Other Implementations letters. Figlet replacement"
HOMEPAGE="http://caca.zoy.org/wiki/toilet"
SRC_URI="http://caca.zoy.org/raw-attachment/wiki/${PN}/${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ppc ~ppc64 ~sparc x86"

RDEPEND=">=media-libs/libcaca-0.99_beta18"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e 's:-g -O2 -fno-strength-reduce -fomit-frame-pointer::' \
		configure || die
	eapply_user
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog NEWS README TODO
}

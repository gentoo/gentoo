# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A clone of the classic game Galaga for the X Window System"
HOMEPAGE="https://sourceforge.net/projects/xgalaga"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

RDEPEND+=" acct-group/gamestat"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.1.0-respect-AR.patch
	"${FILESDIR}"/${PN}-2.1.1.0-function-and-ints.patch
)

src_prepare() {
	default

	eautoreconf

	sed -i \
		-e "/LEVELDIR\|SOUNDDIR/ s:prefix:datadir/${PN}:" \
		-e "/\/scores/ s:prefix:localstatedir/${PN}:" \
		configure || die "sed configure failed"

	sed -i \
		-e "/SOUNDDEFS/ s:(SOUNDSRVDIR):(SOUNDSRVDIR)/bin:" \
		-e 's:make ;:$(MAKE) ;:' \
		Makefile.in || die "sed Makefile.in failed"
}

src_install() {
	dobin xgalaga xgal.sndsrv.oss xgalaga-hyperspace
	dodoc README README.SOUND CHANGES
	newman xgalaga.6x xgalaga.6

	insinto /usr/share/${PN}/sounds
	doins sounds/*.raw

	insinto /usr/share/${PN}/levels
	doins levels/*.xgl

	make_desktop_entry ${PN} XGalaga

	dodir /var/games/${PN}
	touch "${ED}"/var/games/${PN}/scores || die

	fperms -R 660 /var/games/${PN}
	fowners -R root:gamestat /var/games/${PN} /usr/bin/{xgalaga,xgal.sndsrv.oss,xgalaga-hyperspace}
	fperms g+s /usr/bin/{xgalaga,xgal.sndsrv.oss,xgalaga-hyperspace}
}

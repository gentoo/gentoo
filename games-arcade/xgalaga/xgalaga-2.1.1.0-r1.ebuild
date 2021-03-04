# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop toolchain-funcs

DESCRIPTION="A clone of the classic game Galaga for the X Window System"
HOMEPAGE="https://sourceforge.net/projects/xgalaga"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

src_prepare() {
	default

	sed -i \
		-e "/LEVELDIR\|SOUNDDIR/ s:prefix:datadir/${PN}:" \
		-e "/\/scores/ s:prefix:localstatedir/${PN}:" \
		configure \
		|| die "sed configure failed"

	sed -i \
		-e "/SOUNDDEFS/ s:(SOUNDSRVDIR):(SOUNDSRVDIR)/bin:" \
		-e 's:make ;:$(MAKE) ;:' \
		Makefile.in \
		|| die "sed Makefile.in failed"

	sed -i \
		-e "s/AR = ar/AR ?= ar/" \
		libsprite/Makefile.in \
		|| die "sed to respect AR failed"

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	tc-export AR
	econf
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

	dodir /var/lib/${PN}
	touch "${ED}"/var/lib/${PN}/scores || die
	fperms 660 /var/lib/${PN}/scores
}

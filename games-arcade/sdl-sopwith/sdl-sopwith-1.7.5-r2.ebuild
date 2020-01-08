# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop toolchain-funcs

MY_P="${P/sdl-/}"
DESCRIPTION="Port of the classic Sopwith game using LibSDL"
HOMEPAGE="http://sdl-sopwith.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${MY_P}.tar.gz
	https://src.fedoraproject.org/rpms/sopwith/raw/master/f/sopwith.png
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.1.3[video]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	rm acconfig.h || die

	eapply "${FILESDIR}"/${P}-nogtk.patch
	# bug 458504
	eapply "${FILESDIR}"/${P}-video-fix.patch

	mv configure.in configure.ac || die
	eautoreconf
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog FAQ NEWS README TODO doc/*txt
	rm -rf "${ED}/usr/share/doc/sopwith"

	newicon "${DISTDIR}"/sopwith.png ${PN}.png
	make_desktop_entry sopwith "Sopwith" ${PN}
}

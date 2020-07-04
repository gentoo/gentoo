# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Clone of the Rick Dangerous adventure game from the 80's"
HOMEPAGE="http://www.bigorno.net/xrick/"
SRC_URI="http://www.bigorno.net/xrick/${P}.tgz"

LICENSE="GPL-1+ xrick"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""
RESTRICT="mirror bindist" # bug #149097

DEPEND="media-libs/libsdl[video]"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./xrick.6.gz
}

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}*.patch
	sed -i \
		-e "/^run from/d" \
		-e "/data.zip/ s:the directory where xrick is:$(get_libdir)/${PN}.:" \
		xrick.6 || die

	sed -i \
		-e "s:data.zip:/usr/$(get_libdir)/${PN}/data.zip:" \
		src/xrick.c || die

	sed -i \
		-e "s/-g -ansi -pedantic -Wall -W -O2/${CFLAGS}/" \
		-e '/LDFLAGS/s/=/+=/' \
		-e '/CC=/d' \
		-e "/CPP=/ { s/gcc/\$(CC)/; s/\"/'/g }" \
		Makefile || die
}

src_install() {
	dobin xrick
	insinto /usr/"$(get_libdir)"/${PN}
	doins data.zip
	newicon src/xrickST.ico ${PN}.ico
	make_desktop_entry ${PN} ${PN} /usr/share/pixmaps/${PN}.ico
	dodoc README KeyCodes
	doman xrick.6
}

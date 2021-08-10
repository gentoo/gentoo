# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Clone of the arcade game Defender, but with a Linux theme"
HOMEPAGE="http://www.newbreedsoftware.com/defendguin/"
SRC_URI="
	ftp://ftp.tuxpaint.org/unix/x/defendguin/src/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	tc-export CC
	sed	-e "s|\$(DATA_PREFIX)|${EPREFIX}/usr/share/${PN}/|" \
		-e '/^CFLAGS=.*-O2/d' \
		-e '/^CFLAGS=/s|=|+= $(CPPFLAGS) $(LDFLAGS) |' \
		-i Makefile || die
	rm data/images/l2r.sh || die
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r data/.

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} ${PN^}

	doman src/${PN}.6
	dodoc docs/{AUTHORS,CHANGES,README,TODO}.txt
}

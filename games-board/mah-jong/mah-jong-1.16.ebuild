# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs xdg

MY_P="mj-${PV}-src"
DESCRIPTION="A networked Mah Jong program, together with a computer player"
HOMEPAGE="https://mahjong.julianbradfield.org/"
SRC_URI="https://mahjong.julianbradfield.org/Source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	sed -i -e '/^.TH/ s/1/6/' xmj.man || die
}

src_compile() {
	# TILESETPATH value is passed as "char*" into "gui.c"
	emake \
		CC="$(tc-getCC)" \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		CDEBUGFLAGS= \
		TILESETPATH="\"${EPREFIX}/usr/share/${PN}/\""
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		BINDIR="/usr/bin" \
		MANDIR="/usr/share/man/man6" \
		MANSUFFIX=6 \
		INSTPGMFLAGS= \
		install install.man

	insinto "/usr/share/${PN}"
	doins -r fallbacktiles/ tiles-numbered/ tiles-small/
	newicon tiles-v1/tongE.xpm "${PN}.xpm"
	make_desktop_entry xmj Mah-Jong "${PN}"
	dodoc CHANGES ChangeLog *.txt
}

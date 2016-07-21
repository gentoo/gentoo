# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils games

MY_P="${P%%_*}"
MY_P="${MY_P/-/_}"
DEB_V="${P##*_p}"

DESCRIPTION="Spider Solitaire"
HOMEPAGE="http://packages.debian.org/stable/games/spider"
SRC_URI="mirror://debian/pool/main/s/spider/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/s/spider/${MY_P}-${DEB_V}.diff.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="athena"

RDEPEND="x11-libs/libXext
	athena? ( x11-libs/libXaw )
	x11-libs/libXmu
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-misc/imake
	x11-proto/xproto"

S=${WORKDIR}/${MY_P/_/-}.orig

src_prepare() {
	epatch "${WORKDIR}"/${MY_P}-${DEB_V}.diff
	sed -i \
		-e '/MKDIRHIER/s:/X11::' \
		*Imakefile \
		|| die "sed failed"
	rm Makefile
}

src_configure() {
	imake \
		-DUseInstalled \
		-DSmallCards=NO \
		-DRoundCards \
		$(use athena && echo "-DCompileXAW=YES" || echo "-DCompileXlibOnly=YES") \
		-I/usr/lib/X11/config \
		|| die "imake failed"
	sed -i \
		-e '/CC = /d' \
		-e "s/CDEBUGFLAGS = .*$/CDEBUGFLAGS = ${CFLAGS}/" \
		-e '/LDOPTIONS = /s/$/$(LDFLAGS)/' \
		Makefile \
		|| die "sed failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		BINDIR="${GAMES_BINDIR}" \
		MANSUFFIX="6" \
		MANDIR="/usr/share/man/man6" \
		HELPDIR="/usr/share/doc/${PF}" \
		install install.doc install.man

	dodoc README* ChangeLog
	newicon icons/Spider.png ${PN}.png
	newicon -s 32 icons/Spider32x32.png ${PN}.png
	make_desktop_entry spider Spider
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

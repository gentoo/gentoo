# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop epatch gnome2-utils

MY_P="${P%%_*}"
MY_P="${MY_P/-/_}"
DEB_V="${P##*_p}"

DESCRIPTION="Spider Solitaire"
HOMEPAGE="https://packages.debian.org/stable/games/spider"
SRC_URI="mirror://debian/pool/main/s/spider/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/s/spider/${MY_P}-${DEB_V}.diff.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="athena"

RDEPEND="
	x11-libs/libXext
	athena? ( x11-libs/libXaw )
	x11-libs/libXmu
	x11-libs/libXt
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/imake
"

S="${WORKDIR}/${MY_P/_/-}.orig"

src_prepare() {
	default
	epatch "${WORKDIR}"/${MY_P}-${DEB_V}.diff
	sed -i \
		-e '/MKDIRHIER/s:/X11::' \
		*Imakefile \
		|| die "sed failed"
	rm Makefile
}

src_configure() {
	xmkmf \
		-DSmallCards=NO \
		-DRoundCards \
		$(use athena && echo "-DCompileXAW=YES" || echo "-DCompileXlibOnly=YES") \
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
		BINDIR="/usr/bin" \
		MANSUFFIX="6" \
		MANDIR="/usr/share/man/man6" \
		HELPDIR="/usr/share/doc/${PF}" \
		install install.doc install.man

	einstalldocs
	newicon icons/Spider.png ${PN}.png
	newicon -s 32 icons/Spider32x32.png ${PN}.png
	make_desktop_entry spider Spider
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

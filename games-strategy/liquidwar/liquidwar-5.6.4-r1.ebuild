# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="unique multiplayer wargame"
HOMEPAGE="http://www.ufoot.org/liquidwar/"
SRC_URI="https://savannah.nongnu.org/download/liquidwar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="nls"
RESTRICT="test"

RDEPEND=">=media-libs/allegro-4.2:0[X]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-exec-stack.patch \
		"${FILESDIR}"/${P}-ovflfix.patch
	sed -i \
		-e 's:/games::' \
		-e '/^MANDIR/ s:=.*:= $(mandir)/man6:' \
		-e '/^PIXDIR/ s:=.*:= /usr/share/pixmaps:' \
		-e '/^DESKTOPDIR/ s:=.*:= /usr/share/applnk/Games/:' \
		-e '/^INFODIR/ s/=.*/= $(infodir)/' \
		-e '/^GAMEDIR/ s/exec_prefix/bindir/' \
		-e '/install/s:-s ::' \
		-e 's:$(DOCDIR)/txt:$(DOCDIR):g' \
		-e 's:$(GMAKE):$(MAKE):' \
		-e '/^DOCDIR/ s:=.*:= /usr/share/doc/$(PF):' Makefile.in \
		|| die 'sed Makefile.in failed'
	sed -i \
		-e '/^GAMEDIR/ s/$(exec_prefix)/@bindir@/' \
		-e 's:/games::' src/Makefile.in \
		|| die "sed src/Makefile.in failed"
	epatch "${FILESDIR}"/${P}-underlink.patch
}

src_configure() {
	egamesconf \
		--disable-doc-ps \
		--disable-doc-pdf \
		--disable-target-opt \
		$(use_enable x86 asm)
}

src_compile() {
	# skip build_doc target wrt bug 460344
	emake build_bin build_data
}

src_install() {
	emake DESTDIR="${D}" install_nolink
	rm -f "${D}"/usr/share/doc/${PF}/COPYING
	use nls || rm -f "${D}"/usr/share/doc/${PF}/README.*
	prepgamesdirs
}

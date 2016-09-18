# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2-utils xdg

DESCRIPTION="Platform game about a blob and his quest to rescue MIAs from an alien invader"
HOMEPAGE="https://sourceforge.net/projects/blobwars/ https://sourceforge.net/apps/mediawiki/blobwars/index.php?title=Main_Page"
SRC_URI="mirror://sourceforge/blobwars/${P}.tar.gz"

LICENSE="BSD CC-BY-SA-3.0 CC-BY-3.0 GPL-2 LGPL-2.1 fairuse public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl2
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	media-libs/sdl2-image
	media-libs/sdl2-net
	sys-libs/zlib
	virtual/libintl
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_prepare() {
	default
	sed -i -e "/-Werror/d" Makefile || die
}

src_compile() {
	emake \
		RELEASE="1" \
		USEPAK="1"
}

src_install() {
	emake \
		BINDIR="/usr/bin/" \
		USEPAK="1" \
		DESTDIR="${D}" \
		DOCDIR="/usr/share/doc/${PF}/html/" \
		install

	mv -vf \
		"${D}"/usr/share/doc/${PF}/html/{changes,hacking,porting,readme} \
		"${D}"/usr/share/doc/${PF}/
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/frozen-bubble/frozen-bubble-2.2.1_beta1.ebuild,v 1.11 2015/06/13 19:43:23 dilfridge Exp $

EAPI=5
MY_P=${P/_/-}
inherit eutils gnome2-utils perl-module toolchain-funcs games

DESCRIPTION="A Puzzle Bubble clone written in perl (now with network support)"
HOMEPAGE="http://www.frozen-bubble.org/"
SRC_URI="http://www.frozen-bubble.org/data/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.12
	>=dev-libs/glib-2
	>=dev-perl/Alien-SDL-1.413
	dev-perl/Compress-Bzip2
	dev-perl/File-ShareDir
	dev-perl/File-Slurp
	dev-perl/File-Which
	dev-perl/IPC-System-Simple
	>=dev-perl/SDL-2.511
	media-libs/sdl-image[gif,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-pango
	media-libs/sdl-ttf
	virtual/libiconv
	virtual/perl-Getopt-Long
	virtual/perl-IO"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-perl/locale-maketext-lexicon
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-ParseXS
	dev-perl/Module-Build"

S=${WORKDIR}/${MY_P}

src_prepare() {
	perl-module_src_prepare
	epatch "${FILESDIR}"/${P}-Werror.patch
}

src_configure() {
	LD=$(tc-getCC) perl-module_src_configure
}

src_compile() {
	LD=$(tc-getCC) perl-module_src_compile
}

src_install() {
	mydoc="AUTHORS Changes HISTORY README" perl-module_src_install

	dodir "${GAMES_BINDIR}"
	mv -vf "${D}"/usr/bin/f* "${D}/${GAMES_BINDIR}" || die

	newdoc server/README README.server
	newdoc server/init/README README.server.init

	local res
	for res in 16 32 48 64; do
		newicon -s ${res}  share/icons/frozen-bubble-icon-${res}x${res}.png ${PN}.png
	done

	make_desktop_entry ${PN} Frozen-Bubble

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

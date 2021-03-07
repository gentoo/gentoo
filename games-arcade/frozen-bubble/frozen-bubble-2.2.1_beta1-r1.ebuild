# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MY_P="${P/_/-}"

inherit desktop gnome2-utils perl-module toolchain-funcs

DESCRIPTION="A Puzzle Bubble clone written in perl (now with network support)"
HOMEPAGE="http://www.frozen-bubble.org/"
SRC_URI="http://www.frozen-bubble.org/data/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-lang/perl-5.12
	dev-libs/glib:2
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
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-perl/Locale-Maketext-Lexicon
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-ParseXS
	dev-perl/Module-Build
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	perl-module_src_prepare
	eapply "${FILESDIR}"/${P}-Werror.patch
	eapply "${FILESDIR}"/${P}-fix-buffer-size.patch
}

src_configure() {
	LD=$(tc-getCC) perl-module_src_configure
}

src_compile() {
	LD=$(tc-getCC) perl-module_src_compile
}

src_install() {
	mydoc="AUTHORS Changes HISTORY README" perl-module_src_install
	newdoc server/README README.server
	newdoc server/init/README README.server.init

	local res
	for res in 16 32 48 64; do
		newicon -s ${res}  share/icons/frozen-bubble-icon-${res}x${res}.png ${PN}.png
	done

	make_desktop_entry ${PN} Frozen-Bubble
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

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 toolchain-funcs xdg

DESCRIPTION="Turn-based strategy game heavily inspired by the classic Panzer General"
HOMEPAGE="https://lgames.sourceforge.io/LGeneral/"
SRC_URI="
	mirror://sourceforge/lgeneral/${P}.tar.gz
	mirror://sourceforge/lgeneral/kukgen-data-1.1.tar.gz"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.3-fix-utf8.patch
)

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	keepdir /usr/share/${PN}/{ai_modules,music,terrain}

	# Install the free kukgen WW1 campaign
	cd ../${PN}-data-* || die

	dodoc docs/README.kukgen
	newdoc docs/MANUAL MANUAL.kukgen

	insinto /usr/share/${PN}
	doins -r {campaigns,gfx,maps,nations,scenarios,sounds,units}

	local DISABLE_AUTOFORMATTING=yes
	local DOC_CONTENTS=\
"Only the free kukgen WWI campaign has been installed.

If you wish to play the Panzer General (PG) WWII campaign, you need
to convert the original CD-ROM game data by (for example) running:

	SDL_VIDEODRIVER=dummy \\
		lgc-pg -s /path/to/cdrom/DAT -d ${EPREFIX}/usr/share/${PN}

See ${EPREFIX}/usr/share/doc/${PF}/README.lgc-pg* for details."
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst

	# README is redundant with what `make install` says but ensures visibility
	readme.gentoo_print_elog
}

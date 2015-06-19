# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/katawa-shoujo/katawa-shoujo-1.3.ebuild,v 1.3 2015/05/27 11:12:18 ago Exp $

EAPI=5

inherit eutils gnome2-utils games

DESCRIPTION="Bishoujo-style visual novel set in the fictional Yamaku High School for disabled children"
HOMEPAGE="http://katawa-shoujo.com/"
SRC_URI="http://dl.katawa-shoujo.com/gold_1.3/%5b4ls%5d_katawa_shoujo_1.3-%5blinux-x86%5d%5bFCF758CC%5d.tar.bz2 -> ${P}.tar.bz2
	http://dev.gentoo.org/~hasufell/distfiles/katawa-shoujo-48.png
	http://dev.gentoo.org/~hasufell/distfiles/katawa-shoujo-256.png"

# bundled renpy includes licenses of all libraries
LICENSE="CC-BY-NC-ND-3.0
	!system-renpy? ( MIT PSF-2 LGPL-2.1 || ( FTL GPL-2+ ) IJG libpng ZLIB BZIP2 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc +system-renpy"

RDEPEND="system-renpy? ( games-engines/renpy )"

REQUIRED_USE="!system-renpy? ( || ( amd64 x86 ) )"

# Binaries are built extremely weirdly, resulting in errors like:
# BFD: Not enough room for program headers, try linking with -N
#
# Technically, we could make this unconditional because there are no other
# binaries, but it's still good practice.
RESTRICT="!system-renpy? ( strip )"

QA_PREBUILT="${GAMES_PREFIX_OPT}/${PN}/lib/*"

S="${WORKDIR}/Katawa Shoujo-${PV}-linux"

src_install() {
	if use system-renpy; then
		insinto "${GAMES_DATADIR}/${PN}"
		doins -r game/.

		games_make_wrapper ${PN} "renpy '${GAMES_DATADIR}/${PN}'"
	else
		insinto "${GAMES_PREFIX_OPT}/${PN}"
		doins -r game localizations renpy "Katawa Shoujo."{py,sh}

		local host="${CTARGET:-${CHOST}}"
		local arch="${host%%-*}"

		cd lib
		insinto "${GAMES_PREFIX_OPT}/${PN}/lib"
		doins -r linux-${arch} pythonlib2.7
		cd ..

		fperms +x "${GAMES_PREFIX_OPT}/${PN}/lib/linux-${arch}/"{python,"Katawa Shoujo"} \
			"${GAMES_PREFIX_OPT}/${PN}/Katawa Shoujo."{py,sh}

		games_make_wrapper ${PN} "./Katawa\ Shoujo.sh" "${GAMES_PREFIX_OPT}/${PN}"
	fi

	local i
	for i in 48 256; do
		newicon -s ${i} "${DISTDIR}"/${PN}-${i}.png ${PN}.png
	done

	make_desktop_entry ${PN} "Katawa Shoujo"

	if use doc; then
		dodoc "Game Manual.pdf"
	fi

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

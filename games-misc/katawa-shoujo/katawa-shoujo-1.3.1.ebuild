# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils

DESCRIPTION="bishoujo-style visual novel by Four Leaf Studios"
HOMEPAGE="http://katawa-shoujo.com/"
SRC_URI="http://dl.katawa-shoujo.com/gold_1.3.1/%5B4ls%5D_katawa_shoujo_1.3.1-%5Blinux-x86%5D%5B18161880%5D.tar.bz2 -> ${P}.tar.bz2
	https://dev.gentoo.org/~hasufell/distfiles/katawa-shoujo-48.png
	https://dev.gentoo.org/~hasufell/distfiles/katawa-shoujo-256.png"

# bundled renpy includes licenses of all libraries
LICENSE="CC-BY-NC-ND-3.0
	!system-renpy? ( MIT PSF-2 LGPL-2.1 || ( FTL GPL-2+ ) IJG libpng ZLIB BZIP2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +system-renpy"

RDEPEND="system-renpy? ( games-engines/renpy )"

REQUIRED_USE="!system-renpy? ( || ( amd64 x86 ) )"

# Binaries are built extremely weirdly, resulting in errors like:
# BFD: Not enough room for program headers, try linking with -N
#
# Technically, we could make this unconditional because there are no other
# binaries, but it's still good practice.
RESTRICT="!system-renpy? ( strip )"

QA_PREBUILT="/opt/${PN}/lib/*"

S="${WORKDIR}/Katawa Shoujo-${PV}-linux"

src_install() {
	if use system-renpy; then
		insinto "/usr/share/${PN}"
		doins -r game/.

		make_wrapper ${PN} "renpy '/usr/share/${PN}'"
	else
		insinto "/opt/${PN}"
		doins -r game localizations renpy "Katawa Shoujo."{py,sh}

		local host="${CTARGET:-${CHOST}}"
		local arch="${host%%-*}"

		cd lib
		insinto "/opt/${PN}/lib"
		doins -r linux-${arch} pythonlib2.7
		cd ..

		fperms +x "/opt/${PN}/lib/linux-${arch}/"{python,"Katawa Shoujo"} \
			"/opt/${PN}/Katawa Shoujo."{py,sh}

		make_wrapper ${PN} "./Katawa\ Shoujo.sh" "/opt/${PN}"
	fi

	local i
	for i in 48 256; do
		newicon -s ${i} "${DISTDIR}"/${PN}-${i}.png ${PN}.png
	done

	make_desktop_entry ${PN} "Katawa Shoujo"

	if use doc; then
		dodoc "Game Manual.pdf"
	fi
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

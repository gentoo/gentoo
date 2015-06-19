# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/nwmovies/nwmovies-20090223.080954.ebuild,v 1.4 2014/04/06 14:51:32 ulm Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Play Neverwinter Nights movies inside the Linux client"
HOMEPAGE="http://home.roadrunner.com/~nwmovies/"

SRC_URI="${HOMEPAGE}/${PN}/${PN}-v4-public.${PV}.tar.gz"

LICENSE="nwmovies Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=games-rpg/nwn-data-1.29-r3[videos]"
RDEPEND="${DEPEND}
	>=games-rpg/nwn-1.68-r4
	media-video/binkplayer"

S="${WORKDIR}"
DESTDIR="${GAMES_PREFIX_OPT}/nwn"

QA_TEXTRELS="opt/nwn/nwmovies/binklib.so opt/nwn/nwmovies.so"
QA_WX_LOAD="opt/nwn/nwmovies.so"
QA_EXECSTACK="opt/nwn/nwmovies.so"
QA_FLAGS_IGNORED="opt/nwn/nwmovies/binklib.so opt/nwn/nwmovies/libdis/libdisasm.so opt/nwn/nwmovies.so"

src_install() {
	exeinto "${DESTDIR}"
	doexe nwmovies.so nwmovies.pl || die "Installation failed"
	exeinto "${DESTDIR}/nwmovies"
	doexe nwmovies/binklib.so || die "Installation failed"
	exeinto "${DESTDIR}/nwmovies/libdis"
	doexe nwmovies/libdis/libdisasm.so || die "Installation failed"
	insinto "${DESTDIR}"
	doins nwmovies/*.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "When starting nwn the next time, nwmovies will scan the nwmain"
	elog "binary for its hooks, store this information in:"
	elog "  \${HOME}/.nwn/\${LANG}/nwmovies.ini"
	elog "and exit. This is normal."
	elog
	elog "You will have to remove this file whenever you update nwn."
	elog
	elog "If you have sound issues in NWN only when using nwmovies, then"
	elog "you may need to properly setup /etc/asound.conf or the equivalent"
	elog "per-user \${HOME}/.asound.conf, see comment #31 in bug #106789."
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Curses based interpreter for Z-code based text games"
HOMEPAGE="http://frotz.sourceforge.net/"
SRC_URI="http://www.ifarchive.org/if-archive/infocom/interpreters/frotz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="alsa oss"

DEPEND="sys-libs/ncurses:0
	alsa? ( oss? ( media-libs/alsa-oss ) )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/^CC /d' \
		Makefile \
		|| die
	epatch \
		"${FILESDIR}"/${P}-glibc2.10.patch \
		"${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	local OPTS="CONFIG_DIR=${GAMES_SYSCONFDIR}"
	use oss && OPTS="${OPTS} SOUND_DEFS=-DOSS_SOUND SOUND_DEV=/dev/dsp"
	emake ${OPTS} all
}

src_install () {
	dogamesbin {d,}frotz
	doman doc/*.6
	dodoc AUTHORS BUGS ChangeLog HOW_TO_PLAY README TODO \
		doc/{frotz.conf-big,frotz.conf-small}
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "Global config file can be installed in ${GAMES_SYSCONFDIR}/frotz.conf"
	elog "Sample config files are in /usr/share/doc/${PF}"
	echo
}

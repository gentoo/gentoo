# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools gnome2-utils games

DESCRIPTION="High speed arctic racing game based on Tux Racer"
HOMEPAGE="http://extremetuxracer.sourceforge.net/"
SRC_URI="mirror://sourceforge/extremetuxracer/etr-${PV/_/}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	>=media-libs/libsfml-2.2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/etr-${PV/_/}

src_prepare() {
	# kind of ugly in there so we'll do it ourselves
	sed -i -e '/SUBDIRS/s/resources doc//' Makefile.am || die
	eautoreconf
}

src_install() {
	default
	dodoc doc/{code,courses_events,guide,score_algorithm}
	doicon -s 48 resources/etr.png
	doicon -s scalable resources/etr.svg
	domenu resources/etr.desktop
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

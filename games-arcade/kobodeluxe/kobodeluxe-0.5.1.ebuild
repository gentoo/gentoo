# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/kobodeluxe/kobodeluxe-0.5.1.ebuild,v 1.10 2015/03/31 16:08:52 mr_bones_ Exp $

EAPI=5
inherit eutils games

MY_P="KoboDeluxe-${PV/_/}"
DESCRIPTION="An SDL port of xkobo, a addictive space shoot-em-up"
HOMEPAGE="http://www.olofson.net/kobodl/"
SRC_URI="http://www.olofson.net/kobodl/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE="opengl"

DEPEND="media-libs/libsdl
	media-libs/sdl-image[png]
	opengl? ( virtual/opengl )"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./icons.tar.gz
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-glibc29.patch \
		"${FILESDIR}"/${P}-glibc2.10.patch
	# Fix paths
	sed -i \
		-e 's:\$(datadir)/kobo-deluxe:$(datadir)/kobodeluxe:' \
		-e 's:\$(sharedstatedir)/kobo-deluxe/scores:$(localstatedir)/kobodeluxe:' \
		configure || die "sed configure failed"
	sed -i \
		-e 's:kobo-deluxe:kobodeluxe:' \
		data/gfx/Makefile.in \
		data/sfx/Makefile.in || die "sed data/Makefile.in failed"
}

src_configure() {
	egamesconf $(use_enable opengl)
}

src_install () {
	default
	newicon icons/KDE/icons/32x32/kobodl.png ${PN}.png
	make_desktop_entry kobodl "Kobo Deluxe"
	prepgamesdirs
	fperms 2775 "${GAMES_STATEDIR}"/${PN}
}

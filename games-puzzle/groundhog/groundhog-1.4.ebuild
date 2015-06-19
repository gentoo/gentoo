# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/groundhog/groundhog-1.4.ebuild,v 1.26 2015/01/24 08:39:46 mr_bones_ Exp $

EAPI=5
inherit eutils autotools games

DEB_VER="9"
DESCRIPTION="Put the balls in the pockets of the same color by manipulating a maze of tubes"
HOMEPAGE="http://home-2.consunet.nl/~cb007736/groundhog.html"
SRC_URI="http://home-2.consunet.nl/~cb007736/${P}.tar.gz
	mirror://debian/pool/main/g/groundhog/groundhog_${PV}-${DEB_VER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	cd "${WORKDIR}"
	epatch groundhog_${PV}-${DEB_VER}.diff
	cd "${S}"
	sed -e "s:groundhog-1.4/::" -i \
		debian/patches/sv.po.patch || die
	epatch \
		$(sed -e 's:^:debian/patches/:' debian/patches/series) \
		"${FILESDIR}"/${P}-flags.patch
	mv configure.in configure.ac || die
	AT_M4DIR="m4" eautoreconf
	sed -i 's:$(localedir):/usr/share/locale:' \
		$(find . -name 'Makefile.in*') || die
}

src_configure() {
	egamesconf $(use_enable nls)
}

src_install() {
	default
	prepgamesdirs
}

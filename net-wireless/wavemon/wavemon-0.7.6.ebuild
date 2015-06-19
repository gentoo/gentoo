# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wavemon/wavemon-0.7.6.ebuild,v 1.5 2014/08/02 18:30:54 armin76 Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils flag-o-matic toolchain-funcs

DESCRIPTION="Ncurses based monitor for IEEE 802.11 wireless LAN cards"
HOMEPAGE="http://eden-feed.erg.abdn.ac.uk/wavemon/"
SRC_URI="http://eden-feed.erg.abdn.ac.uk/wavemon/stable-releases/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc sparc x86"

IUSE="caps"
RDEPEND="sys-libs/ncurses
	caps? ( sys-libs/libcap )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )
PATCHES=(
	"${FILESDIR}/${PN}-0.6.7-dont-override-CFLAGS.patch"
	"${FILESDIR}/${P}-ncurses-tinfo.patch"
)

src_prepare() {
	# Do not install docs to /usr/share
	sed -i -e '/^install:/s/install-docs//' Makefile.in || die 'sed on Makefile.in failed'

	# automagic on libcap, discovered in bug #448406
	use caps || export ac_cv_lib_cap_cap_get_flag=false

	# Respect CC, fix linking
	tc-export CC
	append-ldflags -pthread

	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install
	# Install man files manually(bug #397807)
	doman wavemon.1
	doman wavemonrc.5
}

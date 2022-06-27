# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic

DESCRIPTION="A set of tools that detect motion between two images"
SRC_URI="http://gemia.de/motion/${P}.tar.gz"
HOMEPAGE="http://motiontrack.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

IUSE="debug graphicsmagick imagemagick multiprocess"

RDEPEND="
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:0= )
		graphicsmagick? ( media-gfx/graphicsmagick:0=[imagemagick] )
	)
	!imagemagick? ( media-libs/gd )
"
DEPEND="${RDEPEND}"

src_configure() {
	# fix missing inline definition
	# with GCC 5, bug 570352
	append-cflags -std=gnu89

	CONFIG_SHELL="${EPREFIX}/bin/bash" \
	econf \
		$(use_enable debug) \
		$(use_enable !imagemagick gd) \
		$(use_enable imagemagick magick) \
		$(use_enable multiprocess cluster)
}

src_install() {
	default
	dodoc src/TheCode.txt
}

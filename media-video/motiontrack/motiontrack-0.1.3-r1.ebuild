# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="A set of tools that detect motion between two images"
SRC_URI="http://gemia.de/motion/${P}.tar.gz"
HOMEPAGE="http://motiontrack.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~ppc64 ~sparc ~mips ~alpha ~hppa ~amd64"

IUSE="debug imagemagick multiprocess"

RDEPEND="
	imagemagick? ( media-gfx/imagemagick )
	!imagemagick? ( media-libs/gd )"
DEPEND="${RDEPEND}"

src_configure() {
	# fix missing inline definition
	# with GCC 5, bug 570352
	append-cflags -std=gnu89

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

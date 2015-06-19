# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gifsicle/gifsicle-1.70.ebuild,v 1.2 2013/05/12 11:20:31 ssuominen Exp $

EAPI=5

DESCRIPTION="A command-line tool for creating, editing, and getting information about GIF images and animations"
HOMEPAGE="http://www.lcdf.org/~eddietwo/gifsicle/"
SRC_URI="http://www.lcdf.org/~eddietwo/${PN}/${P}.tar.gz"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="X"

RDEPEND="X? ( x11-libs/libX11 x11-libs/libXt )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )"

src_configure() {
	local myconf
	use X || myconf='--disable-gifview'

	econf ${myconf}
}

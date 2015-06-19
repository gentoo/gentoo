# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gphotofs/gphotofs-0.5.ebuild,v 1.1 2012/10/30 02:19:33 zx2c4 Exp $

EAPI="4"

DESCRIPTION="FUSE file system for interfacing with digital cameras using gphoto2"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libgphoto2-2.5.0
	>=sys-fs/fuse-2.5
	>=dev-libs/glib-2.6"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gettext-0.14.1"

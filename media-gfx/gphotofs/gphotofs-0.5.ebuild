# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="FUSE file system for interfacing with digital cameras using gphoto2"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libgphoto2-2.5.0
	>=sys-fs/fuse-2.5
	>=dev-libs/glib-2.6"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gettext-0.14.1"

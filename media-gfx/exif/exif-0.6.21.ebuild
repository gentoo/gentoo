# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/exif/exif-0.6.21.ebuild,v 1.7 2012/09/20 13:23:45 xarthisius Exp $

EAPI=4

DESCRIPTION="Small CLI util to show EXIF infos hidden in JPEG files"
HOMEPAGE="http://libexif.sourceforge.net/"
SRC_URI="mirror://sourceforge/libexif/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="nls"

RDEPEND="dev-libs/popt
	 >=media-libs/libexif-${PV}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	econf $(use_enable nls)
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmorgan/gmorgan-0.70.ebuild,v 1.1 2015/08/04 07:58:55 polynomial-c Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DESCRIPTION="Opensource software rhythm station"
HOMEPAGE="http://gmorgan.sourceforge.net/"
SRC_URI="mirror://sourceforge/gmorgan/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="media-libs/alsa-lib
	x11-libs/fltk:1"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

DOCS=(AUTHORS ChangeLog NEWS README)

PATCHES=( "${FILESDIR}/${P}-cxxflags.patch" )

src_configure() {
	econf \
		$(use_enable nls)
}

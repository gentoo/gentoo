# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

MY_P="msilbc-${PV}"

DESCRIPTION="mediastreamer plugin: add iLBC support"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://download.savannah.nongnu.org/releases/linphone/plugins/sources/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="20ms-frames"

RDEPEND="dev-libs/ilbc-rfc3951
	>=media-libs/mediastreamer-2.0.0:="
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	# dev-libs/ilbc-rfc3951 does not ship pkgconfig .pc file,
	# so these variables should be set here to satisfy configure
	ILBC_CFLAGS="/usr/include" ILBC_LIBS="/usr/include -lilbc" \
	econf \
		$(use_enable 20ms-frames)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
}

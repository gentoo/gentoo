# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tgif/tgif-4.2.5.ebuild,v 1.1 2013/01/14 12:07:10 pinkbyte Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils eutils flag-o-matic

MY_P="${PN}-QPL-${PV}"

DESCRIPTION="Xlib base 2-D drawing facility under X11"
HOMEPAGE="http://bourbon.usc.edu/tgif/index.html"
SRC_URI="ftp://bourbon.usc.edu/pub/${PN}/${MY_P}.tar.gz"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	x11-proto/xproto"
RDEPEND="${DEPEND}
	media-libs/netpbm"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS ChangeLog HISTORY NEWS README )

src_prepare() {
	sed -i \
		-e 's/^CFLAGS=/CFLAGS+=/' \
		-e 's:^TGIFDIR.*:TGIFDIR = $(datadir)/tgif:' \
		Makefile.am || die 'sed on Makefile.am failed'

	append-cppflags -D_DONT_USE_MKTEMP -DHAS_STREAMS_SUPPORT

	autotools-utils_src_prepare
}

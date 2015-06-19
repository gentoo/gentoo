# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dvda-author/dvda-author-10.06.ebuild,v 1.1 2010/08/30 23:27:06 radhermit Exp $

EAPI=2

inherit eutils

DESCRIPTION="Author a DVD-Audio DVD"
HOMEPAGE="http://dvd-audio.sourceforge.net"
SRC_URI="mirror://sourceforge/dvd-audio/${P}-300.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=media-sound/sox-14.1[png]
	>=media-libs/flac-1.2.1[ogg]"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2"

src_prepare() {
	# Fix parallel make
	sed -i -e 's:^\(\tcd ${MAYBE_CDRTOOLS}\):@HAVE_CDRTOOLS_BUILD_TRUE@\1:' \
		Makefile.in || die "sed failed"

	# Don't pre-strip binaries
	sed -i -e 's:$LIBS -s:$LIBS:' configure || die "sed failed"
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--with-config=/etc \
		$(use_with debug debug full)
}

src_install() {
	newbin src/dvda ${PN} || die "newbin failed"
	insinto /etc
	doins ${PN}.conf || die "doins failed"
	dodoc AUTHORS BUGS ChangeLog EXAMPLES HOWTO.conf LIMITATIONS NEWS TODO \
		|| die "dodoc failed"
}

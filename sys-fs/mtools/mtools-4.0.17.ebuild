# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="utilities to access MS-DOS disks from Unix without mounting them"
HOMEPAGE="http://mtools.linux.lu/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="X"

DEPEND="
	X? (
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXt
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	# Don't throw errors on existing directories
	sed -i -e "s:mkdir:mkdir -p:" mkinstalldirs || die
}

src_configure() {
	econf \
		--sysconfdir=/etc/mtools \
		$(use_with X x)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README* Release.notes

	insinto /etc/mtools
	doins mtools.conf
	# default is fine
	sed -i -e '/^SAMPLE FILE$/s:^:#:' "${D}"/etc/mtools/mtools.conf || die
}

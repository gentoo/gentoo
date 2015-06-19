# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gigedit/gigedit-0.2.0.ebuild,v 1.4 2012/05/05 08:20:42 mgorny Exp $

EAPI=3

DESCRIPTION="An instrument editor for gig files"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	>=media-libs/libgig-3.3.0
	>=media-libs/libsndfile-1.0.2
	>=media-sound/linuxsampler-0.5.1"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

src_compile() {
	# fails with parallel jobs
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Video maid is the AVI file editor"
HOMEPAGE="http://vmaid.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/vmaid/48081/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa ao mime"

RDEPEND="x11-libs/gtk+:2
	ao? ( media-libs/libao )
	!ao? ( alsa? ( >=media-libs/alsa-lib-0.9 ) )
	mime? ( x11-misc/shared-mime-info )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	app-text/scrollkeeper"

src_configure() {
	econf \
		$(use_enable mime) \
		--with-ao=$(usex ao) \
		--with-alsa=$(usex alsa) \
		--without-w32
}
src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS CONTRIBUTORS ChangeLog NEWS README
	dohtml -r doc/{en,ja}
}

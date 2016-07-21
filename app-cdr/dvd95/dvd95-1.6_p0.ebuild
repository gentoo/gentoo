# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils autotools

DESCRIPTION="DVD95 is a Gnome application to convert DVD9 to DVD5"
HOMEPAGE="http://dvd95.sourceforge.net/"
SRC_URI="mirror://sourceforge/dvd95/${P/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_3dnow nls cpu_flags_x86_mmx mpeg cpu_flags_x86_sse cpu_flags_x86_sse2"

RDEPEND=">=gnome-base/libgnomeui-2
	dev-libs/libxml2
	media-libs/libdvdread
	mpeg? ( media-libs/libmpeg2 )
	media-video/mplayer"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext
		dev-util/intltool )
	sys-apps/sed"

S=${WORKDIR}/${P/_}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3_p2-desktop-entry.patch
	epatch "${FILESDIR}"/${P}-link-libxml2.patch
	sed -i -e "s:-O3:${CFLAGS}:" configure.in || die "sed failed"
	echo "dvd95.glade" >> po/POTFILES.in || die "translation fix failed"
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable nls) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_3dnow 3dnow) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable mpeg libmpeg2)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog
}

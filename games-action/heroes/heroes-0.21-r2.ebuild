# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools

data_ver=1.5
snd_trk_ver=1.0
snd_eff_ver=1.0

DESCRIPTION="Heroes Enjoy Riding Over Empty Slabs: similar to Tron and Nibbles"
HOMEPAGE="http://heroes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-data-${data_ver}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-sound-tracks-${snd_trk_ver}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-sound-effects-${snd_eff_ver}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="ggi nls sdl"
RESTRICT="test"

RDEPEND="
	ggi? ( media-libs/libggi media-libs/libgii media-libs/libmikmod )
	nls? ( virtual/libintl )
	sdl? ( media-libs/libsdl media-libs/sdl-mixer )
	!sdl? ( !ggi? ( media-libs/libsdl media-libs/sdl-mixer ) )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

	#56118
PATCHES=(
	"${FILESDIR}/${P}"-automake-1.12.patch
	"${FILESDIR}/${P}"-gcc4.patch
	"${FILESDIR}/${P}"-underlink.patch
	"${FILESDIR}/${PV}"-cvs-segfault-fix.patch
)

src_prepare() {
	default
	sed -i 's:$(localedir):/usr/share/locale:' \
		$(find . -name 'Makefile.in*') || die
	eautoreconf
}

src_configure() {
	local myconf

	if use sdl || ! use ggi ; then
		myconf="${myconf} --with-sdl --with-sdl-mixer"
	else
		myconf="${myconf} --with-ggi --with-mikmod"
	fi

	local pkg
	for pkg in ${A//.tar.bz2} ; do
		cd "${WORKDIR}"/${pkg}
		econf \
			--disable-heroes-debug \
			--disable-optimizations \
			$(use_enable nls) \
			${myconf}
	done
}

src_install() {
	local pkg
	for pkg in ${A//.tar.bz2} ; do
		cd "${WORKDIR}"/${pkg}
		emake DESTDIR="${D}" install
	done
}

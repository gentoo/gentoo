# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

MY_P="smpeg-${PV}"

DESCRIPTION="SDL MPEG Player Library"
HOMEPAGE="https://icculus.org/smpeg/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="cpu_flags_x86_mmx"

DEPEND="media-libs/libsdl2[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-smpeg2-config.patch
)

src_prepare() {
	default

	# avoid file collision with media-libs/smpeg
	sed -i -e '/plaympeg/d' Makefile.am || die

	AT_M4DIR="${ESYSROOT}/usr/share/aclocal acinclude" eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-rpath
		--disable-sdltest
		--enable-debug # disabling this only passes extra optimizations
		$(use_enable cpu_flags_x86_mmx mmx)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

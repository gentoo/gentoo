# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="SDL MPEG Player Library"
HOMEPAGE="https://icculus.org/smpeg/"
SRC_URI="https://mirrors.dotsrc.org/lokigames/open-source/smpeg/${P}.tar.gz
	mirror://gentoo/${P}-gtkm4.patch.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="cpu_flags_x86_mmx opengl"

RDEPEND="
	media-libs/libsdl[opengl?,sound,video,${MULTILIB_USEDEP}]
	opengl? (
		virtual/glu[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-automake.patch
	"${FILESDIR}"/${P}-config.patch
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-format.patch
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-gnu-stack.patch
	"${FILESDIR}"/${P}-m4.patch
	"${FILESDIR}"/${P}-malloc.patch
	"${FILESDIR}"/${P}-missing-init.patch
	"${FILESDIR}"/${P}-mmx.patch
	"${FILESDIR}"/${P}-PIC.patch
	"${WORKDIR}"/${P}-gtkm4.patch
)

src_prepare() {
	default

	rm acinclude.m4 || die
	AT_M4DIR="m4" eautoreconf
}

multilib_src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-libs -lnsl -lsocket

	local myeconfargs=(
		--disable-gtk-player
		--enable-debug # disabling this only passes extra optimizations
		--without-x # does not actually use X, only causes a headers check
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable opengl opengl-player)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="serial graphics adapter bios option rom for x86"
HOMEPAGE="https://code.google.com/p/sgabios/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	!binary? ( https://dev.gentoo.org/~cardoe/distfiles/${P}.tar.xz )
	binary? ( https://dev.gentoo.org/~cardoe/distfiles/${P}-bins.tar.xz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+binary"

REQUIRED_USE="!amd64? ( !x86? ( binary ) )"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-build-cc.patch #552280
)

src_prepare() {
	if  use binary; then
		eapply_user
		return
	fi
	default
}

src_compile() {
	use binary && return

	tc-ld-disable-gold
	tc-export_build_env BUILD_CC
	emake \
		BUILD_CC="${BUILD_CC}" \
		BUILD_CFLAGS="${BUILD_CFLAGS}" \
		BUILD_LDFLAGS="${BUILD_LDFLAGS}" \
		BUILD_CPPFLAGS="${BUILD_CPPFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		AR="$(tc-getAR)" \
		OBJCOPY="$(tc-getOBJCOPY)"
}

src_install() {
	insinto /usr/share/sgabios

	if use binary ; then
		doins bins/sgabios.bin
	else
		doins sgabios.bin
	fi
}

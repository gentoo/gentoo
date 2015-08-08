# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib eutils

DESCRIPTION="Disassembler library for the x86/-64 architecture sets"
HOMEPAGE="http://udis86.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="test"

DEPEND="test? (
		amd64? ( dev-lang/yasm )
		x86? ( dev-lang/yasm )
		x86-fbsd? ( dev-lang/yasm )
	)"
RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r1
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"

PATCHES=(
	"${FILESDIR}"/${P}-yasm.patch
)

src_configure() {
	local myeconfargs=(
		--disable-static
		--enable-shared
		--with-pic
	)

	autotools-multilib_src_configure
}

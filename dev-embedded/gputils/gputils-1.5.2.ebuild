# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs flag-o-matic

DESCRIPTION="Tools including assembler, linker and librarian for PIC microcontrollers"
HOMEPAGE="https://gputils.sourceforge.io"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc"

PATCHES=(
	"${FILESDIR}"/gputils-1.5.2-fix-invalid-operator.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #369291, bug #818802
	tc-ld-disable-gold

	# Their configure script tries to do funky things with default
	# compiler selection.  Force our own defaults instead.
	tc-export CC

	# LTO currently causes various segfaults in dev-embedded/sdcc
	# sys-devel/gcc-11.3.0 '-O3 -flto'
	filter-flags '-flto*'

	local myeconfargs=(
		$(use_enable doc html-doc)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use doc && dodoc doc/gputils.pdf
}

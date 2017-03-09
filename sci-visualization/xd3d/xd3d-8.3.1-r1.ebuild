# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fortran-2 toolchain-funcs

DESCRIPTION="Scientific visualization tool"
HOMEPAGE="http://www.cmap.polytechnique.fr/~jouve/xd3d/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	app-shells/tcsh"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.diff
	"${FILESDIR}"/${P}-parallel.patch
	"${FILESDIR}"/${P}-rotated.patch
	"${FILESDIR}"/${P}-cflags.patch
)

src_prepare() {
	default
	sed \
		-e 's:"zutil.h":<zlib.h>:g' \
		-i src/qlib/timestuff.c || die
	sed \
		-e "s:##D##:${ED%/}:" \
		-e "s:##lib##:$(get_libdir):" \
		-i RULES.gentoo \
		|| die "failed to set up RULES.gentoo"
}

src_configure() {
	tc-export CC
	./configure -arch=gentoo || die "configure failed."
}

src_install() {
	dodir /usr/bin
	default
	dodoc FORMATS

	use doc && dodoc -r Manuals
	if use examples; then
		mv {E,e}xamples || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Software package for algebraic, geometric and combinatorial problems"
HOMEPAGE="https://4ti2.github.io"
SRC_URI="https://github.com/4ti2/4ti2/releases/download/Release_${PV//./_}/${P}.tar.gz
	https://dev.gentoo.org/~mjo/distfiles/${P}-musl.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv ~x86"

RDEPEND="
	sci-mathematics/glpk:=[gmp]
	dev-libs/gmp:0=[cxx(+)]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-slibtool.patch"
	"${WORKDIR}/${P}-musl.patch"
)

src_prepare() {
	default

	# The swig subdir is not used on Gentoo, and in 1.6.10, they
	# actually forgot to ship it. Let's make extra sure that e.g.
	# we don't waste time autoreconfing it.
	rm -rf swig || die
	sed -e '/SUBDIRS += swig/d' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	# This is not pointless: configure.ac disables shared libraries and
	# enables static libraries by default.
	econf --enable-shared --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

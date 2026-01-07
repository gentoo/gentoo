# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo fortran-2 flag-o-matic toolchain-funcs

DESCRIPTION="Scientific visualization tool"
HOMEPAGE="https://www.ljll.fr/jouve/xd3d/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc examples"

RDEPEND="x11-libs/libXpm"
DEPEND="${RDEPEND}"
BDEPEND="app-shells/tcsh"

PATCHES=(
	"${FILESDIR}"/${P}-r1-gentoo.patch
	"${FILESDIR}"/${P}-sane-makefiles.patch
	"${FILESDIR}"/${P}-rotated.patch
	"${FILESDIR}"/${P}-c99.patch
)

src_prepare() {
	default

	sed -i -e "s:##lib##:$(get_libdir):" RULES.gentoo || die "failed to set up RULES.gentoo"
}

src_configure() {
	tc-export CC

	export MY_AR="$(tc-getAR)"
	export MY_RANLIB="$(tc-getRANLIB)"

	# bug #863368
	append-flags -fno-strict-aliasing
	# bug #875236
	append-cflags -std=gnu17
	# I do not want to muck with redefining function names and linking problems, easiest way to deal with that
	append-fflags -fno-underscoring
	filter-lto

	# GCC 10 workaround
	# bug #722426
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	edo ./configure -arch=gentoo
}

src_install() {
	dodir /usr/bin
	emake INSTALL_DIR="${ED}/usr/bin" install
	dodoc FORMATS

	use doc && dodoc -r Manuals

	if use examples; then
		mv {E,e}xamples || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

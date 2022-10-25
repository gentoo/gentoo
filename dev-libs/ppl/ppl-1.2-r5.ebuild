# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="The Parma Polyhedra Library for numerical analysis of complex systems"
HOMEPAGE="http://bugseng.com/products/ppl"
SRC_URI="http://bugseng.com/products/ppl/download/ftp/releases/${PV}/${P}.tar.xz
	https://dev.gentoo.org/~juippis/distfiles/tmp/ppl-1.2-r3-disable-boeing-tests.patch"

LICENSE="GPL-3"
SLOT="0/4.14" # SONAMEs
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~sparc-solaris"
IUSE="cdd +cxx doc lpsol pch test"

RDEPEND=">=dev-libs/gmp-6[cxx(+)]
	lpsol? ( sci-mathematics/glpk )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	sys-devel/m4"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/disable-mipproblem2.patch"
	"${FILESDIR}/disable-containsintegerpoint1.patch"
	"${DISTDIR}/ppl-1.2-r3-disable-boeing-tests.patch"
	"${FILESDIR}/fix-clang-build.patch"
)

src_prepare() {
	default

	# The patch should do this, but then the diff makes it run
	# afoul of the Gentoo patch size limit.
	rm demos/ppl_lpsol/examples/boeing[12].mps || die

	eautoreconf
}

src_configure() {
	local interfaces=( c )
	use cxx && interfaces+=( cxx )
	econf \
		--disable-debugging \
		--disable-optimization \
		$(use_enable doc documentation) \
		$(use_enable cdd ppl_lcdd) \
		$(use_enable lpsol ppl_lpsol) \
		$(use_enable pch) \
		--enable-interfaces="${interfaces[*]}" \
		$(use test && echo --enable-check=quick)
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die

	pushd "${ED}/usr/share/doc/${PF}" >/dev/null || die
	rm gpl* fdl* || die  # Redundant license texts
	rm *.ps.gz || die 	 # Each ps.gz has a pdf counterpart

	if ! use doc ; then
		rm -r *-html/ *.pdf || die
	fi
}

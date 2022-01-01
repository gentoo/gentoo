# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The Parma Polyhedra Library for numerical analysis of complex systems"
HOMEPAGE="http://bugseng.com/products/ppl"
SRC_URI="http://bugseng.com/products/ppl/download/ftp/releases/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0/4.14" # SONAMEs
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 sparc ~x86 ~amd64-linux ~sparc-solaris"
IUSE="cdd +cxx doc lpsol pch static-libs test"

RDEPEND=">=dev-libs/gmp-6[cxx]
	lpsol? ( sci-mathematics/glpk )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	sys-devel/m4"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/disable-mipproblem2.patch"
	"${FILESDIR}/disable-containsintegerpoint1.patch"
	"${FILESDIR}/disable-boeing-tests.patch"
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
		$(use_enable static-libs static) \
		--enable-interfaces="${interfaces[*]}" \
		$(use test && echo --enable-check=quick)
}

src_install() {
	default
	if ! use static-libs; then
		find "${ED}"/usr -name 'libppl*.la' -delete || die
	fi

	pushd "${ED}/usr/share/doc/${PF}" >/dev/null || die
	rm gpl* fdl* || die
	if ! use doc ; then
		rm -r *-html/ *.ps.gz *.pdf || die
	fi
}

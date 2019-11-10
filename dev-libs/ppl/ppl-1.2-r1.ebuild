# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="The Parma Polyhedra Library for numerical analysis of complex systems"
HOMEPAGE="http://bugseng.com/products/ppl"
SRC_URI="http://bugseng.com/products/ppl/download/ftp/releases/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0/4.14" # SONAMEs
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~sparc-solaris"
IUSE="+cxx doc lpsol pch static-libs test"

RDEPEND=">=dev-libs/gmp-6[cxx]
	lpsol? ( sci-mathematics/glpk )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	sys-devel/m4"

RESTRICT="!test? ( test )"

src_configure() {
	local interfaces=( c )
	use cxx && interfaces+=( cxx )
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--disable-debugging \
		--disable-optimization \
		$(use_enable doc documentation) \
		$(use_enable lpsol ppl_lpsol) \
		$(use_enable pch) \
		$(use_enable static-libs static) \
		--enable-interfaces="${interfaces[*]}" \
		$(use test && echo --enable-check=quick)
}

src_install() {
	default
	use static-libs || find "${ED}"/usr -name 'libppl*.la' -delete

	pushd "${ED}/usr/share/doc/${PF}" >/dev/null || die
	rm gpl* fdl* || die
	if ! use doc ; then
		rm -r *-html/ *.ps.gz *.pdf || die
	fi
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ppl/ppl-1.1.ebuild,v 1.4 2015/03/17 05:27:11 vapier Exp $

EAPI="5"

DESCRIPTION="The Parma Polyhedra Library provides numerical abstractions for analysis of complex systems"
HOMEPAGE="http://bugseng.com/products/ppl"
SRC_URI="http://bugseng.com/products/ppl/download/ftp/releases/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0/4.13" # SONAMEs
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~sparc-solaris"
IUSE="+cxx doc lpsol pch static-libs test"

RDEPEND=">=dev-libs/gmp-6[cxx]
	lpsol? ( sci-mathematics/glpk )
	!dev-libs/cloog-ppl"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	sys-devel/m4"

pkg_setup() {
	if use test ; then
		ewarn "The PPL testsuite will be run."
		ewarn "Note that this can take several hours to complete on a fast machine."
	fi
}

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

src_test() {
	# default src_test runs with -j1, overriding it here saves about
	# 30 minutes and is recommended by upstream
	emake check
}

src_install() {
	default
	use static-libs || find "${ED}"/usr -name 'libppl*.la' -delete

	pushd "${ED}/usr/share/doc/${PF}" >/dev/null || die
	rm gpl* fdl* || die
	if ! use doc; then
		rm -r *-html/ *.ps.gz *.pdf || die
	fi
}

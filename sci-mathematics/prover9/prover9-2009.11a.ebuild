# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs versionator

MY_PN="LADR"
typeset -u MY_PV
MY_PV=$(replace_all_version_separators '-')
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Automated theorem prover for first-order and equational logic"
HOMEPAGE="http://www.cs.unm.edu/~mccune/mace4/"
SRC_URI="
	http://www.cs.unm.edu/~mccune/mace4/download/${MY_P}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${MY_PN}-2009-11A-makefile.patch.xz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
IUSE="examples"

PATCHES=(
	"${WORKDIR}"/${MY_PN}-2009-11A-makefile.patch
	"${FILESDIR}"/${MY_PN}-2009-11A-manpages.patch
	)

S="${WORKDIR}/${MY_P}/"

src_prepare() {
	MAKEOPTS+=" -j1"
	epatch ${PATCHES[@]}
	sed \
		-e "/^CC =/s:gcc:$(tc-getCC):g" \
		-i */Makefile || die
}

src_compile() {
	emake all
}

src_install () {
	dobin \
		bin/attack \
		bin/autosketches4 \
		bin/clausefilter \
		bin/clausetester \
		bin/complex \
		bin/directproof \
		bin/dprofiles \
		bin/fof-prover9 \
		bin/gen_trc_defs \
		bin/get_givens \
		bin/get_interps \
		bin/get_kept \
		bin/gvizify \
		bin/idfilter \
		bin/interpfilter \
		bin/interpformat \
		bin/isofilter \
		bin/isofilter0 \
		bin/isofilter2 \
		bin/ladr_to_tptp \
		bin/latfilter \
		bin/looper \
		bin/mace4 \
		bin/miniscope \
		bin/mirror-flip \
		bin/newauto \
		bin/newsax \
		bin/olfilter \
		bin/perm3 \
		bin/proof3fo.xsl \
		bin/prooftrans \
		bin/prover9 \
		bin/renamer \
		bin/rewriter \
		bin/sigtest \
		bin/test_clause_eval \
		bin/test_complex \
		bin/tptp_to_ladr \
		bin/unfast \
		bin/upper-covers

	doman \
		manpages/interpformat.1 \
		manpages/isofilter.1 \
		manpages/prooftrans.1  \
		manpages/mace4.1 \
		manpages/prover9.1  \
		manpages/clausefilter.1 \
		manpages/clausetester.1 \
		manpages/interpfilter.1 \
		manpages/rewriter.1 \
		manpages/prover9-apps.1

	dohtml ladr/index.html.master ladr/html/*

	insinto /usr/$(get_libdir)
	dolib.so ladr/.libs/libladr.so.4.0.0

	dosym libladr.so.4.0.0 /usr/$(get_libdir)/libladr.so.4
	dosym libladr.so.4.0.0 /usr/$(get_libdir)/libladr.so

	dodir /usr/include/ladr
	insinto /usr/include/ladr
	doins ladr/*.h

	if use examples; then
		insinto /usr/share/${PN}/examples
		doins prover9.examples/*

		# The prover9-mace4 script is installed as an example script
		# to avoid confusion with the GUI sci-mathematics/p9m4 prover9mace4.py
		insinto /usr/share/${PN}/scripts
		doins bin/prover9-mace4
	fi
}

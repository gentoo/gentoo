# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PV=${PV#1}

DESCRIPTION="A restriction enzyme database"
HOMEPAGE="http://rebase.neb.com"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="emboss minimal"

RDEPEND="emboss? ( >=sci-biology/emboss-5.0.0 )"
DEPEND="${RDEPEND}"

RESTRICT="binchecks strip"

src_compile() {
	if use emboss; then
		echo; einfo "Indexing Rebase for usage with EMBOSS."
		mkdir REBASE || die
		EMBOSS_DATA="." rebaseextract -auto -infile withrefm.${MY_PV} \
				-protofile proto.${MY_PV} -equivalences \
				|| die "Indexing Rebase failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins withrefm.${MY_PV} proto.${MY_PV}
	fi
	newdoc REBASE.DOC README
	if use emboss; then
		insinto /usr/share/EMBOSS/data/REBASE
		doins REBASE/embossre.{enz,ref,sup}
		insinto /usr/share/EMBOSS/data
		doins REBASE/embossre.equ
	fi
}

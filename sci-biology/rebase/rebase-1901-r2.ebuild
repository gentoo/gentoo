# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV#1}"

DESCRIPTION="A restriction enzyme database"
HOMEPAGE="http://rebase.neb.com"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="emboss minimal"
RESTRICT="binchecks strip"

BDEPEND="emboss? ( sci-biology/emboss )"
RDEPEND="${BDEPEND}"

src_compile() {
	if use emboss; then
		einfo
		einfo "Indexing Rebase for usage with EMBOSS"
		mkdir REBASE || die
		EMBOSS_DATA="." rebaseextract -auto -infile withrefm.${MY_PV} \
				-protofile proto.${MY_PV} -equivalences \
				|| die "Indexing Rebase failed"
		einfo
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

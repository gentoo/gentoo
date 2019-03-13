# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A protein families and domains database"
HOMEPAGE="https://prosite.expasy.org/"
SRC_URI="ftp://ftp.expasy.org/databases/prosite/old_releases/prosite${PV//./_}.tar.bz2"

LICENSE="swiss-prot"
SLOT="0"
# Minimal build keeps only the indexed files (if applicable).
# The non-indexed database is not installed.
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emboss minimal"

DEPEND="emboss? ( sci-biology/emboss )"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_compile() {
	if use emboss; then
		mkdir PROSITE || die
		einfo
		einfo "Indexing PROSITE for usage with EMBOSS"
		EMBOSS_DATA="." prosextract -auto -prositedir "${S}" || die "Indexing PROSITE failed"
		einfo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins *.{doc,dat}
	fi

	if use emboss; then
		insinto /usr/share/EMBOSS/data/PROSITE
		doins -r PROSITE/.
	fi
}

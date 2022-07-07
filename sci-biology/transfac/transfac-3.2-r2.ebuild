# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A database of eucaryotic transcription factors"
HOMEPAGE="http://www.gene-regulation.com/pub/databases.html"
SRC_URI="ftp://ftp.ebi.ac.uk/pub/databases/${PN}/${PN}32.tar.Z"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="3"
# Minimal build keeps only the indexed files (if applicable) and the documentation.
# The non-indexed database is not installed.
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emboss minimal"

BDEPEND="emboss? ( sci-biology/emboss )"
RDEPEND="${BDEPEND}"

src_compile() {
	if use emboss; then
		einfo
		einfo "Indexing TRANSFAC for usage with EMBOSS"
		EMBOSS_DATA="." tfextract -auto -infile class.dat || die "Indexing TRANSFAC failed"
		einfo
	fi
}

src_install() {
	newdoc readme.txt README

	if ! use minimal; then
		insinto /usr/share/transfac-${SLOT}
		doins *.dat
	fi

	if use emboss; then
		insinto /usr/share/EMBOSS/data
		doins tf*
	fi
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils prefix toolchain-funcs versionator

MY_P="${PN}$(delete_all_version_separators)"

DESCRIPTION="Protein Secondary Structure Prediction"
HOMEPAGE="http://bioinf.cs.ucl.ac.uk/psipred/"
SRC_URI="http://bioinf.cs.ucl.ac.uk/downloads/${PN}/${MY_P}.tar.gz"

LICENSE="psipred"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	sci-biology/ncbi-tools
	|| ( sci-biology/update-blastdb sci-biology/ncbi-tools++ )"
DEPEND=""

S="${WORKDIR}"

src_prepare() {
	rm -f bin/*
	epatch \
		"${FILESDIR}"/3.1-Makefile.patch \
		"${FILESDIR}"/3.1-path.patch \
		"${FILESDIR}"/${PV}-fgets.patch
	eprefixify runpsipred*
}

src_compile() {
	emake -C src CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake -C src DESTDIR="${D}" install || die "installation failed"
	dobin runpsipred* bin/* BLAST+/runpsipred* || die
	insinto /usr/share/${PN}
	doins -r data || die "failed to install data"
	dodoc README || die "nothing to read"
}

pkg_postinst() {
	elog "Please use the update_blastdb.pl in order to"
	elog "maintain your own local blastdb"
}

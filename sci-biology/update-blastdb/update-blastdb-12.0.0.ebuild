# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

MY_PV="$(replace_all_version_separators _)"

DESCRIPTION="update_blastdb.pl for local blast db maintainance"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=toolkit"
SRC_URI="ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/ARCHIVE/${MY_PV}/ncbi_cxx--${MY_PV}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-lang/perl
	!sci-biology/ncbi-tools++"
DEPEND=""

S="${WORKDIR}"

src_install() {
	dobin ncbi_cxx--${MY_PV}/src/app/blast/update_blastdb.pl
}

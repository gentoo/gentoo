# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="update_blastdb.pl for local blast db maintainance"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=toolkit"
SRC_URI="ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/ARCHIVE/${MY_PV}/ncbi_cxx--${MY_PV}.tar.gz"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	!sci-biology/ncbi-tools++"

src_install() {
	dobin ncbi_cxx--${MY_PV}/src/app/blast/update_blastdb.pl
}

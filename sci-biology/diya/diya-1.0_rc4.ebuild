# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit perl-module

DESCRIPTION="Do It Yourself Annotation, tools & libraries for sequence assembly & annotation"
HOMEPAGE="http://gmod.org/wiki/Diya"
SRC_URI="mirror://sourceforge/diyg/files/diya/diya-1.0/diya-${PV/_/-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="-minimal"
KEYWORDS="~amd64 ~x86"

DEPEND="sci-biology/bioperl
	dev-perl/Data-Utilities
	dev-perl/XML-Simple"
RDEPEND="${DEPEND}
	!minimal? (
		sci-biology/mummer
		sci-biology/glimmer
		sci-biology/trnascan-se
		sci-biology/infernal )"

# see ftp://ftp.ncbi.nih.gov/blast/ to check if blast and blast+ are different from ncbi-tools and ncbi-tools++
# * rfamscan.pl v0.1      (http://www.sanger.ac.uk/Users/sgj/code/)
# * UniRef50                              (http://www.ebi.ac.uk/uniref/)
# * Protein Clusters (ftp://ftp.ncbi.nih.gov/genomes/Bacteria/CLUSTERS/)
# The file cddid_all.tbl can be found at ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/.

S="${WORKDIR}/diya-${PV/_/-}"

SRC_TEST=do

src_install() {
	mydoc="INSTALL README docs/diya.html"
	perl-module_src_install
	insinto /usr/share/${PN}
	doins -r diya.conf docs examples scripts
}

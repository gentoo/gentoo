# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

BIOPERL_RELEASE=1.6.9

MY_PN=BioPerl-Run
MODULE_AUTHOR=CJFIELDS
MODULE_VERSION=1.006900
inherit perl-module

DESCRIPTION="Perl tools for bioinformatics - Wrapper modules around key bioinformatics applications"
HOMEPAGE="http://www.bioperl.org/"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal test"
#SRC_TEST="do"

RESTRICT="test"

CDEPEND=">=sci-biology/bioperl-${BIOPERL_RELEASE}
	!minimal? (
		dev-perl/Algorithm-Diff
		dev-perl/XML-Twig
		dev-perl/IO-String
		dev-perl/IPC-Run
		dev-perl/File-Sort
	)"
DEPEND="dev-perl/Module-Build
	${CDEPEND}"
RDEPEND="${CDEPEND}"

src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
	# TODO: File collision in Bio/ConfigData.pm (a Module::Build internal file)
	# with sci-biology/bioperl. Workaround: the "nuke it from orbit" solution :D
	#find "${D}" -name '*ConfigData*' -print -delete
}

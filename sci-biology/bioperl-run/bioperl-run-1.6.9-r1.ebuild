# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BIOPERL_RELEASE=1.6.9

DIST_AUTHOR=CJFIELDS
DIST_NAME=BioPerl-Run
DIST_VERSION=1.006900
inherit perl-module

DESCRIPTION="Perl wrapper modules for key bioinformatics applications"
HOMEPAGE="http://www.bioperl.org/"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="minimal test"
RESTRICT="test"

RDEPEND="
	>=sci-biology/bioperl-${BIOPERL_RELEASE}
	!minimal? (
		dev-perl/Algorithm-Diff
		dev-perl/XML-Twig
		dev-perl/IO-String
		dev-perl/IPC-Run
		dev-perl/File-Sort
	)"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"

mydoc="AUTHORS BUGS FAQ"

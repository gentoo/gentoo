# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LDS
DIST_VERSION=1.30
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="An API for hierarchical tag/value structures"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="genbank store xml"

RDEPEND="
	genbank? ( dev-perl/CGI )
	store? ( virtual/perl-DB_File )
	xml? ( dev-perl/XML-Parser )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PATCHES=(
	"${FILESDIR}/${PN}-${DIST_VERSION}-no-xml-parser-check.patch"
)
PERL_RM_FILES=(
	# Incomplete, instructs not to use, deps not in Gentoo
	"Boulder/Labbase.pm"
)
src_prepare() {
	use xml || PERL_RM_FILES+=(
		"Boulder/XML.pm"
	)
	use genbank || PERL_RM_FILES+=(
		"Boulder/Genbank.pm"
		"Stone/GB_Sequence.pm"
		"doc/genbank_tags.txt"
		"eg/gb_get"
		"eg/gb_search"
		"eg/genbank.pl"
		"eg/genbank2.pl"
		"eg/genbank3.pl"
	)
	use store || PERL_RM_FILES+=(
		"Boulder/Store.pm"
		"t/store.t"
	)
	perl-module_src_prepare
}

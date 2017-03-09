# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_NAME=HTML-Formatter
DIST_AUTHOR=NIGELM
DIST_VERSION=2.14
inherit perl-module

DESCRIPTION="HTML Formatter"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	dev-perl/Font-AFM
	dev-perl/HTML-Tree
	virtual/perl-IO
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		dev-perl/File-Slurper
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.960.0
	)
"
src_test() {
	local badfile
	perl_rm_files t/author-* t/release-*
	for badfile in t/000-report-versions.t META.yml; do
		einfo "Stripping bad test dependencies from ${badfile}"
		sed -i -r -e '/Test::(CPAN|EOL|Kwalitee|NoTabs|Pod|Port|YAML)/d' "${badfile}" || die "Can't fix bad deps in ${badfile}"
	done
	perl-module_src_test
}

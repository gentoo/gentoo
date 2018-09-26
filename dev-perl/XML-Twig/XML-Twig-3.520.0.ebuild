# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIROD
DIST_VERSION=3.52
inherit perl-module

DESCRIPTION="Process huge XML documents in tree mode"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="nls test"

RDEPEND="
	>=dev-perl/XML-Parser-2.31
	>=virtual/perl-Scalar-List-Utils-1.230.0
	>=virtual/perl-Encode-2.240.100_rc
	>=dev-libs/expat-1.95.5
	dev-perl/Tie-IxHash
	dev-perl/XML-XPath
	>=dev-perl/libwww-perl-6.40.0
	>=dev-perl/HTML-Parser-3.690.0
	nls? (
		>=dev-perl/Text-Iconv-1.2-r1
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/XML-Handler-YAWriter-0.230.0
		>=dev-perl/XML-SAX-Writer-0.530.0
	)
"

src_test() {
	perl_rm_files "t/pod.t" "t/pod_coverage.t" "t/test_changes.t" \
		"t/test_kwalitee.t" "t/test_meta_json.t"
	perl-module_src_test
}

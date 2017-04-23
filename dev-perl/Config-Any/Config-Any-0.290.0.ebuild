# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="Load configuration from different file formats, transparently"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~x86 ~ppc-aix"
IUSE="test minimal +json"

# json should pull Cpanel-JSON-XS
RDEPEND="
	>=dev-perl/Module-Pluggable-3.600.0
	!minimal? (
		>=dev-perl/Config-General-2.470.0
	)
	minimal? (
		!<dev-perl/config-general-2.470.0
		!<dev-perl/Config-General-2.470.0
	)
	json? (
		|| (
			dev-perl/JSON-MaybeXS
			dev-perl/JSON-XS
			>=virtual/perl-JSON-PP-2
			dev-perl/JSON
		)
	)
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}

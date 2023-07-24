# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=0.33
inherit perl-module

DESCRIPTION="Load configuration from different file formats, transparently"

SLOT="0"
KEYWORDS="amd64 arm ~ppc x86"
IUSE="+conf +ini +json +xml +yaml"

RDEPEND="
	>=dev-perl/Module-Pluggable-3.600.0
	conf? (
		>=dev-perl/Config-General-2.480.0
	)
	!conf? (
		!<dev-perl/config-general-2.480.0
		!<dev-perl/Config-General-2.480.0
	)
	ini? (
		dev-perl/Config-Tiny
	)
	json? (
		|| (
			dev-perl/Cpanel-JSON-XS
			dev-perl/JSON-MaybeXS
			dev-perl/JSON-XS
			>=virtual/perl-JSON-PP-2
			dev-perl/JSON
		)
	)
	xml? (
		dev-perl/XML-NamespaceSupport
		dev-perl/XML-Simple
	)
	yaml? (
		|| (
			dev-perl/YAML-LibYAML
			>=dev-perl/YAML-Syck-0.700.0
			dev-perl/YAML
		)
	)
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=YVES
DIST_VERSION=2.39
inherit perl-module

DESCRIPTION="Accurately serialize a data structure as Perl code"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
	dev-perl/B-Utils
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	virtual/perl-IO
	virtual/perl-Text-Balanced
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-ExtUtils-CBuilder
	dev-perl/ExtUtils-Depends
	virtual/perl-Carp
	test? (
		virtual/perl-Test-Simple
		dev-perl/JSON-XS
		dev-perl/PadWalker
	)
"

src_prepare() {
	# Add DDS.pm shortcut
	echo 'yes' > "${S}"/.answer
	perl-module_src_prepare
}

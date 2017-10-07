# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=YVES
DIST_VERSION=2.40
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
	virtual/perl-IO-Compress
	virtual/perl-MIME-Base64
	virtual/perl-Text-Balanced
	dev-perl/PadWalker
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-Carp
	virtual/perl-ExtUtils-CBuilder
	dev-perl/ExtUtils-Depends
	test? (
		virtual/perl-Test-Simple
		dev-perl/JSON-XS
	)
"
PATCHES=( "${FILESDIR}/${P}-perl526.patch" )
src_prepare() {
	# Add DDS.pm shortcut
	echo 'yes' > "${S}"/.answer
	perl-module_src_prepare
}

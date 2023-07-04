# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=YVES
DIST_VERSION=2.42
inherit perl-module

DESCRIPTION="Accurately serialize a data structure as Perl code"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

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
BDEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-Carp
	virtual/perl-ExtUtils-CBuilder
	dev-perl/ExtUtils-Depends
	test? (
		dev-perl/Cpanel-JSON-XS
		virtual/perl-Test-Simple
	)
"

src_prepare() {
	# Add DDS.pm shortcut
	echo 'yes' > "${S}"/.answer || die
	perl-module_src_prepare
}

src_compile() {
	./Build --config optimize="${CFLAGS}" build || die
}

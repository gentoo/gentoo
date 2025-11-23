# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ATOOMIC
DIST_VERSION=1.96
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Take a line from a crontab and find out when events will occur"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/perl-Time-Local
	dev-perl/Set-Crontab
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-Test
		virtual/perl-Test-Simple
		dev-perl/Test-Deep
	)
"

src_prepare() {
	perl-module_src_prepare
	mkdir "${S}"/examples/ || die
	mv "${S}/cron_event_predict.plx" "${S}/examples/cron_event_predict.plx" || die
	sed -i 's|^cron_event_predict.plx|examples/cron_event_predict.plx|' "${S}"/MANIFEST || die
	sed -i "/cron_event_predict.plx/d" Makefile.PL || die
}

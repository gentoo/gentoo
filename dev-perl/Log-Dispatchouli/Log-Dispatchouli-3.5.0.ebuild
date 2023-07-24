# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=3.005
inherit perl-module

DESCRIPTION="Simple wrapper around Log::Dispatch"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="minimal"

# r: Log::Dispatch::File -> Log-Dispatch
# r: Log::Dispatch::Screen -> Log-Dispatch
# r: Log::Dispatch::Syslog -> Log-Dispatch
# r: Scalar::Util - Scalar-List-Utils
# r: overload, strict, warnings -> perl
RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	dev-perl/Log-Dispatch
	dev-perl/Log-Dispatch-Array
	dev-perl/Params-Util
	virtual/perl-Scalar-List-Utils
	dev-perl/String-Flogger
	dev-perl/Sub-Exporter
	>=dev-perl/Sub-Exporter-GlobExporter-0.2.0
	>=virtual/perl-Sys-Syslog-0.160.0
	>=dev-perl/Try-Tiny-0.40.0
"
# t: File::Spec::Functions -> File-Spec
# t: base, lib -> perl
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-File-Temp
		dev-perl/JSON-MaybeXS
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"

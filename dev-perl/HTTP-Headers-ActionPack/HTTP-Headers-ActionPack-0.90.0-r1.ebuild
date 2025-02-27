# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="HTTP Action, Adventure and Excitement"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	dev-perl/HTTP-Date
	dev-perl/HTTP-Message
	virtual/perl-Scalar-List-Utils
	virtual/perl-MIME-Base64
	dev-perl/Module-Runtime
	dev-perl/Sub-Exporter
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Warnings
	)
"

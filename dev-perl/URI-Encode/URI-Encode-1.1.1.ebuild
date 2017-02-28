# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MITHUN
DIST_VERSION=v1.1.1
inherit perl-module

DESCRIPTION="Simple percent Encoding/Decoding"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Encode-2.120.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	virtual/perl-version
	test? ( virtual/perl-Test-Simple )
"

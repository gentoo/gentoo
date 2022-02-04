# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Functions for working with IO::Handle like objects"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-perl/IO-String
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Exporter
	dev-perl/asa
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-1.1.10
	)
"

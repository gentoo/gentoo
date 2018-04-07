# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Temporary changing working directory (chdir)"

SLOT="0"
KEYWORDS="amd64 hppa ~ppc ~x86"
IUSE="test minimal"
# Cwd -> perl-File-Spec
RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Exporter
	virtual/perl-if
	virtual/perl-parent
"
# CPAN::Meta::Prereqs -> perl-CPAN-Meta
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		dev-perl/Test-Requires
		virtual/perl-Test-Simple
		!minimal? (
			dev-perl/File-Copy-Link
		)
	)
"

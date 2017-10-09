# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MUIR
DIST_SECTION=modules
DIST_VERSION=0.85
inherit perl-module

DESCRIPTION="Framework to provide start/stop/reload for a daemon"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/File-Flock-2013.60.0
	dev-perl/File-Slurp
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Text-Tabs+Wrap
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/AnyEvent
		dev-perl/Event
		dev-perl/Eval-LineNumbers
		virtual/perl-Time-HiRes
	)
"

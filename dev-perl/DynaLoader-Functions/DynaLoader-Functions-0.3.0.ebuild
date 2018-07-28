# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.003
inherit perl-module

DESCRIPTION="Deconstructed Dynamic C Library Loading"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"

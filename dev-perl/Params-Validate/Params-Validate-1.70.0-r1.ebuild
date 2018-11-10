# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=1.07
inherit perl-module

DESCRIPTION="Flexible system for validation of method/function call parameters"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Attribute-Handlers
	dev-perl/Module-Implementation
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.35
	test? (
		dev-perl/Test-Fatal
	)
"

SRC_TEST="do"

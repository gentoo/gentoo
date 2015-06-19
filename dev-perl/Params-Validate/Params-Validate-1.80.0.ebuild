# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Params-Validate/Params-Validate-1.80.0.ebuild,v 1.5 2015/06/13 21:35:33 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=1.08
inherit perl-module

DESCRIPTION="A module to provide a flexible system for validation method/function call parameters"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Attribute-Handlers
	dev-perl/Module-Implementation
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.35
	test? (
		dev-perl/Test-Fatal
		dev-perl/Readonly
		dev-perl/Readonly-XS
		dev-perl/Test-Taint
	)
"

SRC_TEST="do"

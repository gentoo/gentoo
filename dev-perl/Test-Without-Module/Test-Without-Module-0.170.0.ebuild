# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Without-Module/Test-Without-Module-0.170.0.ebuild,v 1.1 2013/02/03 18:27:11 tove Exp $

EAPI=5

MODULE_AUTHOR=CORION
MODULE_VERSION=0.17
inherit perl-module

DESCRIPTION="Test fallback behaviour in absence of modules"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? (
		dev-perl/File-Slurp
		dev-perl/Test-Pod
	)
"

SRC_TEST=do

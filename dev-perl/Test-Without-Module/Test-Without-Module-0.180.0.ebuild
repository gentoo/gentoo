# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CORION
MODULE_VERSION=0.18
inherit perl-module

DESCRIPTION="Test fallback behaviour in absence of modules"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

DEPEND="
	test? (
		dev-perl/File-Slurp
		dev-perl/Test-Pod
	)
"

SRC_TEST=do

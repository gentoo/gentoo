# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/indirect/indirect-0.270.0.ebuild,v 1.1 2013/02/01 20:07:07 tove Exp $

EAPI=5

MODULE_AUTHOR=VPIT
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="Lexically warn about using the indirect object syntax"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

DEPEND="
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST=do

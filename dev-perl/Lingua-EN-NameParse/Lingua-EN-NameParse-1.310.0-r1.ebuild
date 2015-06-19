# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-EN-NameParse/Lingua-EN-NameParse-1.310.0-r1.ebuild,v 1.1 2014/08/23 22:25:02 axs Exp $

EAPI=5

MODULE_AUTHOR=KIMRYAN
MODULE_VERSION=1.31
inherit perl-module

DESCRIPTION="Manipulate persons name"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="dev-perl/Parse-RecDescent"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"

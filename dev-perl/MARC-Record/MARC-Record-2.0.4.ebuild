# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MARC-Record/MARC-Record-2.0.4.ebuild,v 1.1 2013/02/10 09:48:41 tove Exp $

EAPI=5

MODULE_AUTHOR=GMCHARLT
MODULE_VERSION=2.0.4
inherit perl-module

DESCRIPTION="MARC manipulation (library bibliographic)"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do

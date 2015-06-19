# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DT/XML-DT-0.670.0.ebuild,v 1.1 2015/03/17 09:24:04 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=AMBS
MODULE_SECTION=XML
MODULE_VERSION=0.66
inherit perl-module

DESCRIPTION="A perl XML down translate module"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	dev-perl/libwww-perl
	>=dev-perl/XML-LibXML-1.600.0
	>=dev-perl/XML-DTDParser-2.0.0
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do"

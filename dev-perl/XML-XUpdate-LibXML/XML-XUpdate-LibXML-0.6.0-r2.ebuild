# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PAJAS
inherit perl-module

DESCRIPTION="Process XUpdate commands over an XML document"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc sparc x86"

RDEPEND="
	>=dev-perl/XML-LibXML-1.610.0
	dev-perl/XML-LibXML-Iterator
"
BDEPEND="${RDEPEND}
"

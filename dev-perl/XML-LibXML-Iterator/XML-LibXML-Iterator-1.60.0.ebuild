# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Iterator class for XML::LibXML parsed documents"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

RDEPEND="
	>=dev-perl/XML-LibXML-1.520.0
	dev-perl/XML-NodeFilter
"
BDEPEND="${DEPEND}
	>=dev-perl/Module-Build-0.280.0
"

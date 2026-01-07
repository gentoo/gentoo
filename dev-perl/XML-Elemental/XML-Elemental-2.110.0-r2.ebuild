# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMA
DIST_VERSION=2.11
inherit perl-module

DESCRIPTION="XML::Parser style and generic classes for handling of XML data"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~hppa ~sparc x86"

RDEPEND="
	dev-perl/XML-Parser
	dev-perl/XML-SAX
	dev-perl/Class-Accessor
"
BDEPEND="${RDEPEND}
"

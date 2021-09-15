# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ABW
DIST_VERSION=2.17
inherit perl-module

DESCRIPTION="XML plugins for the Template Toolkit"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-perl/Template-Toolkit-2.150.0-r1
	dev-perl/XML-DOM
	dev-perl/XML-Parser
	dev-perl/XML-RSS
	dev-perl/XML-Simple
	dev-perl/XML-XPath
"
BDEPEND="${RDEPEND}
"

PATCHES=( "${FILESDIR}/bug-144689-branch-2.17.patch" )

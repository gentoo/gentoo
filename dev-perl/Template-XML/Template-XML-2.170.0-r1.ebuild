# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ABW
MODULE_VERSION=2.17
inherit perl-module

DESCRIPTION="XML plugins for the Template Toolkit"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-perl/Template-Toolkit-2.15-r1
	dev-perl/XML-DOM
	dev-perl/XML-Parser
	dev-perl/XML-RSS
	dev-perl/XML-Simple
	dev-perl/XML-XPath"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/bug-144689-branch-2.17.patch" )
SRC_TEST="do"

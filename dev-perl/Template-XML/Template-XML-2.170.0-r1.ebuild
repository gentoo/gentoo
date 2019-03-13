# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ABW
MODULE_VERSION=2.17
inherit perl-module

DESCRIPTION="XML plugins for the Template Toolkit"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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

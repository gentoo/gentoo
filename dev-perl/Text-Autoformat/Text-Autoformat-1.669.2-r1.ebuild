# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=Text-Autoformat
MODULE_AUTHOR=DCONWAY
MODULE_VERSION=1.669002
inherit perl-module

DESCRIPTION="Automatic text wrapping and reformatting"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/Text-Reform-1.11
	virtual/perl-version"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=do

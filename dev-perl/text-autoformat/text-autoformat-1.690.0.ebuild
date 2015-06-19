# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/text-autoformat/text-autoformat-1.690.0.ebuild,v 1.2 2015/06/13 22:19:51 dilfridge Exp $

EAPI=5

MY_PN=Text-Autoformat
MODULE_AUTHOR=DCONWAY
MODULE_VERSION=1.669002
inherit perl-module

DESCRIPTION="Automatic text wrapping and reformatting"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/text-reform-1.11
	virtual/perl-version"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=do

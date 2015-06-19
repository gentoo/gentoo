# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MARC-Charset/MARC-Charset-1.350.0-r1.ebuild,v 1.1 2014/08/26 19:28:34 axs Exp $

EAPI=5

MODULE_AUTHOR=GMCHARLT
MODULE_VERSION=1.35
inherit perl-module

DESCRIPTION="convert MARC-8 encoded strings to UTF-8"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="
	dev-lang/perl[gdbm]
	dev-perl/XML-SAX
	dev-perl/Class-Accessor
"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST=do

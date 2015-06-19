# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-Session/Apache-Session-1.930.0.ebuild,v 1.2 2015/06/13 19:25:48 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=1.93
inherit perl-module

DESCRIPTION="A persistence framework for session data"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-File-Temp
	virtual/perl-IO
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/Test-Deep-0.82.0
		>=dev-perl/Test-Exception-0.150.0
		>=virtual/perl-Test-Simple-0.470.0
	)
"

SRC_TEST=do

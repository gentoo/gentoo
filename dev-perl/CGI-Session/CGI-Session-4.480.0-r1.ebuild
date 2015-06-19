# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CGI-Session/CGI-Session-4.480.0-r1.ebuild,v 1.4 2015/06/13 19:22:11 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MARKSTOS
MODULE_VERSION=4.48
inherit perl-module

DESCRIPTION="persistent session data in CGI applications "

SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Scalar-List-Utils
	>=dev-perl/CGI-3.26
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/CGI-Simple
		dev-perl/Test-Pod
	)
"

SRC_TEST="do"

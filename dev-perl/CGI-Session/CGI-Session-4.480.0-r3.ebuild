# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MARKSTOS
DIST_VERSION=4.48
inherit perl-module

DESCRIPTION="persistent session data in CGI applications"
# Bug: https://bugs.gentoo.org/show_bug.cgi?id=721398
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Scalar-List-Utils
	>=dev-perl/CGI-3.26
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/CGI-Simple
	)
"

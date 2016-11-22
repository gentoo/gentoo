# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CHROMATIC
MODULE_VERSION=1.20150527
inherit perl-module

DESCRIPTION="Perl extension for emulating troublesome interfaces"

SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Scalar-List-Utils
	>=dev-perl/UNIVERSAL-isa-1.201.106.140
	>=dev-perl/UNIVERSAL-can-1.201.106.170
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/CGI-4.150.0
		>=dev-perl/Test-Exception-0.310.0
		>=dev-perl/Test-Warn-0.230.0
		>=virtual/perl-Test-Simple-0.980.0
	)
"

src_prepare() {
	cp "${FILESDIR}/${PN}-${MODULE_VERSION}-INSTALL.SKIP" \
		"${S}/INSTALL.SKIP" || die "Cant copy INSTALL.SKIP file"
	perl-module_src_prepare
}
SRC_TEST="do parallel"

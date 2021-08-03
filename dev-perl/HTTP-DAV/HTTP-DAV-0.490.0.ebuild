# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=COSIMO
DIST_VERSION=0.49
inherit perl-module

DESCRIPTION="A WebDAV client library for Perl5"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	>=dev-perl/libwww-perl-5.480.0
	virtual/perl-Scalar-List-Utils
	dev-perl/URI
	dev-perl/XML-DOM
"
BDEPEND="${RDEPEND}"

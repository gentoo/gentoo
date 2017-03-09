# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOMZO
inherit perl-module

DESCRIPTION="Perl interface to file system quotas"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="virtual/perl-ExtUtils-MakeMaker"

# Tests need real FS access/root permissions and are interactive
DIST_TEST=skip

src_prepare() {
	default

	# disable AFS completely for now, need somebody who can really test it
	sed -i -e 's|-d "/afs"|0|' Makefile.PL || die "sed failed"
}

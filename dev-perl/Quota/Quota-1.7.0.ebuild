# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TOMZO
inherit perl-module

DESCRIPTION="Quota - Perl interface to file system quotas"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

# Tests need real FS access/root permissions and are interactive
SRC_TEST="skip"

src_prepare() {
	# disable AFS completely for now, need somebody who can really test it
	sed -i -e 's|-d "/afs"|0|' Makefile.PL || die "sed failed"
}

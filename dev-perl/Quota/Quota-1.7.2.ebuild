# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOMZO
inherit perl-module toolchain-funcs flag-o-matic

DESCRIPTION="Perl interface to file system quotas"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	sys-fs/quota[rpc]
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

# Tests need real FS access/root permissions and are interactive
DIST_TEST=skip

src_prepare() {
	default
	export mymake="OPTIMIZE=$($(tc-getPKG_CONFIG) --cflags libtirpc)"

	# disable AFS completely for now, need somebody who can really test it
	sed -i -e 's|-d "/afs"|0|' Makefile.PL || die "sed failed"
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SALVA
DIST_VERSION=0.04
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="SASL DIGEST-MD5 authentication (RFC2831)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

src_prepare() {
	mkdir -p examples || die "Can't mkdir examples"
	mv -v digest-md5-auth.pl examples/ || die "Can't move digest-md5-auth.pl"
	sed -i -r -e 's|^(digest-md5-auth.pl)|examples/\1|' MANIFEST || die "Can't fix manifest"
	perl-module_src_prepare
}

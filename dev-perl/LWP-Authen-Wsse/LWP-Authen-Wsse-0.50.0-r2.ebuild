# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AUTRIJUS
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Library for enabling X-WSSE authentication in LWP"

SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

RDEPEND="
	virtual/perl-MIME-Base64
	dev-perl/Digest-SHA1
"
BDEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

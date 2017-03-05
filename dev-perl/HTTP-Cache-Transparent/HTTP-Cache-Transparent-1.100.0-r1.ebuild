# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MATTIASH
MODULE_VERSION=1.1
inherit perl-module

DESCRIPTION="Cache the result of http get-requests persistently"

SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE="test"

RDEPEND="dev-perl/libwww-perl
	virtual/perl-Digest-MD5
	virtual/perl-Storable"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ANDK
MODULE_VERSION=2.08
inherit perl-module

DESCRIPTION="Write a CHECKSUMS file for a directory as on CPAN"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="virtual/perl-IO-Compress
	dev-perl/Compress-Bzip2
	dev-perl/Data-Compare
	virtual/perl-Digest-SHA
	virtual/perl-Digest-MD5
	virtual/perl-File-Temp
	virtual/perl-IO"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_test() {
	local bad_files=(
		"t/00signature.t" # Online test, invalid if dist tweaked
		t/52podcover.t    # Author Test
		t/pod.t           # Author Test
	)
	perl_rm_files "${bad_files[@]}"
	perl-module_src_test
}

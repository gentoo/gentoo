# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=AUDREYT
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="Traditional and Simplified Chinese mappings"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=virtual/perl-Encode-1.410.0
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.35-no-dot-inc.patch"
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)

	perl-module_src_compile

	# this file is converted to Perl.pm during src_configure
	# and not needed after that, but has to be removed after compile
	# to avoid confusing pm_to_blib, but has to be done before src_test
	# as tests run against the result of this.
	rm -vf "blib/lib/Encode/HanConvert/Perl.pm-orig" || die "Can't remove Perl.pm-orig"
}

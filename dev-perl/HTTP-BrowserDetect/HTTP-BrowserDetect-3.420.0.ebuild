# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=3.42
inherit perl-module

DESCRIPTION="Determine Web browser, version, and platform from an HTTP user agent string"

SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc x86"

BDEPEND="
	test? (
		dev-perl/Path-Tiny
		dev-perl/Test-Differences
		dev-perl/Test-NoWarnings
		dev-perl/Test-Warnings
	)
"

src_test() {
	perl_rm_files t/release-*.t
	perl-module_src_test
}

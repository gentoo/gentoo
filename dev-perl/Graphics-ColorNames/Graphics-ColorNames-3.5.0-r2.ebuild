# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRWO
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="Defines RGB values for common color names"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=virtual/perl-Module-Load-0.100.0
	dev-perl/Color-Library
	dev-perl/Tie-Sub
"

BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Most
	)
"

src_test() {
	perl_rm_files t/90-pod-coverage.t t/90-pod.t \
		t/90-file-port.t
	perl-module_src_test
}

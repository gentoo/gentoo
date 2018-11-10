# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MICHIELB
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="Determine file type"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND=">=dev-perl/File-BaseDir-0.03
		>=dev-perl/File-DesktopEntry-0.0
		x11-misc/shared-mime-info"

DEPEND="${RDEPEND}
		dev-perl/Module-Build
		test? (
			virtual/perl-Test-Simple
		)
		virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do parallel"

src_test() {
	perl_rm_files t/08_changes.t t/06_pod_ok.t t/07_pod_cover.t \
		t/09_no404s.t
	perl-module_src_test
}

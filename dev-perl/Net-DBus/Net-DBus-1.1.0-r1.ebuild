# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DANBERR
inherit perl-module

DESCRIPTION="Perl extension for the DBus message system"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-apps/dbus
	virtual/perl-Time-HiRes
	dev-perl/XML-Twig
"
BDEPEND="${RDEPEND}
	virtual/pkgconfig
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
DEPEND="
	sys-apps/dbus
"

src_test() {
	perl_rm_files t/10-pod-coverage.t t/05-pod.t t/12-changes.t
	perl-module_src_test
}

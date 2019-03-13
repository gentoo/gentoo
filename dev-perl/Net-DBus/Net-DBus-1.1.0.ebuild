# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DANBERR
inherit perl-module

DESCRIPTION="Perl extension for the DBus message system"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	sys-apps/dbus
	virtual/perl-Time-HiRes
	dev-perl/XML-Twig
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/10-pod-coverage.t t/05-pod.t t/12-changes.t
	perl-module_src_test
}

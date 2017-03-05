# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="ACID"
MODULE_VERSION=v${PV}
inherit perl-module

DESCRIPTION="Faster but less secure than Class::Std"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-Std-0.11.0
	virtual/perl-version
	virtual/perl-Data-Dumper
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t t/96_prereq_build.t \
		t/97_kwalitee.t
	perl-module_src_test
}

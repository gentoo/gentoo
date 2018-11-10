# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=VPIT
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl::Critic policy against indirect method calls"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND=">=dev-perl/indirect-0.250.0
	dev-perl/Perl-Critic-Dynamic
	dev-perl/Perl-Critic"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST=do

src_test() {
	perl_rm_files t/91-pod.t t/99-kwalitee.t t/92-pod-coverage.t \
		t/95-portability-files.t
	perl-module_src_test
}

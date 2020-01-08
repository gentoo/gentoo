# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.81
inherit perl-module

DESCRIPTION="Create DateTime parser classes and objects"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc x86 ~ppc-aix ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/DateTime
	dev-perl/Class-Factory-Util
	>=dev-perl/Params-Validate-0.91
	>=dev-perl/DateTime-Format-Strptime-1.0800"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

SRC_TEST=do

src_test() {
	perl_rm_files t/release-pod-syntax.t t/release-eol.t t/release-pod-linkcheck.t \
		t/release-cpan-changes.t t/release-no-tabs.t t/990pod.t
	perl-module_src_test
}

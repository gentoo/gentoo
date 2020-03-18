# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JHOBLITT
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Parses ISO8601 formats"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/DateTime
	dev-perl/DateTime-Format-Builder"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/File-Find-Rule
	)"

SRC_TEST=do

src_test() {
	perl_rm_files t/00_distribution.t t/99_pod.t
	perl-module_src_test
}

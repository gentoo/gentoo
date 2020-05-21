# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.20
inherit perl-module

DESCRIPTION="convenience wrappers around Carp::Assert"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Carp-Assert
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
	)
"
PERL_RM_FILES=(
	"t/pod-coverage.t"
	"t/pod.t"
)
src_test() {
	perl-module_src_test
	local MODULES=(
		"Carp::Assert::More ${DIST_VERSION}"
	)
	for dep in "${MODULES[@]}"; do
		perl -Mblib="${S}" -M"${dep} ()" -e1 ||
			die "Could not load ${dep}"
	done
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SKAJI
DIST_VERSION=v${PV}
DIST_EXAMPLES=("example/*" "benchmarks")
inherit perl-module

DESCRIPTION="Moose minus the antlers"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.140.0
	>=virtual/perl-XSLoader-0.20.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-Devel-PPPort-3.420.0
	>=virtual/perl-ExtUtils-ParseXS-3.220.0
	>=dev-perl/Module-Build-0.400.500
	>=dev-perl/Module-Build-XSUtil-0.190.0
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Fatal
		dev-perl/Test-LeakTrace
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Output
		dev-perl/Test-Requires
		dev-perl/Try-Tiny
	)
"

src_configure() {
	unset LD
	[[ -n "${CCLD}" ]] && export LD="${CCLD}"
	# we have to do this outside src_compile
	# as the stupid thing recompiles in src_install
	myconf=(
		--config "optimize=${CFLAGS}"
	)
	perl-module_src_configure
}

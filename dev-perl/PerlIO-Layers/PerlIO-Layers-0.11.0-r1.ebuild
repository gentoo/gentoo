# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LEONT
DIST_VERSION=0.011

inherit perl-module

DESCRIPTION="Querying your filehandle's capabilities"

SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

# needs List::Util
RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-XSLoader
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.820.0
	)
"
PERL_RM_FILES=(
	t/release-pod-coverage.t
	t/release-pod-syntax.t
)
src_configure() {
	unset LD
	[[ -n "${CCLD}" ]] && export LD="${CCLD}"
	perl-module_src_configure
}
src_compile() {
	./Build --config optimize="${CFLAGS}" build || die
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CNANGEL
DIST_VERSION="0.100"

inherit perl-module

DESCRIPTION="Perl extension for libconfig"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~mips ~s390 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PERL_RM_FILES=(
	"t/boilerplate.t"
	"t/pod-coverage.t"
	"t/pod-spell.t"
	"t/pod.t"
)
RDEPEND="
	dev-libs/libconfig:=
	virtual/perl-XSLoader
"
DEPEND="
	dev-libs/libconfig:=
"
BDEPEND="${RDEPEND}
	dev-perl/ExtUtils-PkgConfig
	test? (
		>=dev-perl/Test-Exception-0.430.0
		>=dev-perl/Test-Deep-1.127.0
		>=dev-perl/Test-Warn-0.320.0
	)
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

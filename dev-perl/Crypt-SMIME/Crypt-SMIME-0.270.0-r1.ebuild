# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIKAGE
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="S/MIME message signing, verification, encryption and decryption"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/openssl-0.9.9:0=
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/ExtUtils-PkgConfig
	dev-perl/ExtUtils-CChecker
	>=virtual/perl-ExtUtils-Constant-0.230.0
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
		!minimal? (
			>=dev-perl/Test-Taint-1.60.0
			>=dev-perl/Taint-Util-0.80.0
		)
	)
"
PERL_RM_FILES=(
	t/boilerplate.t
	t/manifest.t
	t/pod-coverage.t
	t/pod.t
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

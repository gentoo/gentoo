# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="DROLSKY"
DIST_VERSION=1.23

inherit perl-module

DESCRIPTION="Perl wrapper for libmagic"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~ppc64 sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-apps/file
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	dev-perl/Config-AutoConf
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
src_configure() {
	unset LD
	[[ -n "${CCLD}" ]] && export LD="${CCLD}"
	perl-module_src_configure
}
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

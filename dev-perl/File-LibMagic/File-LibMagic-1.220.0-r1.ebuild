# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="DROLSKY"
DIST_VERSION="1.22"

inherit perl-module

DESCRIPTION="Perl wrapper for libmagic"

SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	# Note: the usual approach of passing this to compile doesn't work here
	# as something is weird and recompiles the code 3 times, once in `make`,
	# once in `make test` and once again in `make install`, the latter clobbering
	# the same files generated in other passes. The only sane way to avoid this is
	# to convince EUMM to hardcode the settings in Makefile, and at least then, it does
	# the same thing in all 3 stages. BUT THIS SHOULDNT BE HAPPENING
	# https://github.com/houseabsolute/File-LibMagic/issues/28
	myconf=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_configure
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.009
inherit perl-module

DESCRIPTION="the Eksblowfish block cipher"

SLOT="0"
KEYWORDS="amd64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-Mix-0.1.0
	virtual/perl-Exporter
	>=virtual/perl-MIME-Base64-2.210.0
	virtual/perl-XSLoader
	virtual/perl-parent
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	>=virtual/perl-ExtUtils-CBuilder-0.15
	test? (
		virtual/perl-Test-Simple
	)
"
src_configure() {
	# Overriding this breaks build,
	# as people always set this to a real LD
	# but a CCLD is expected
	# If you know what you're doing, export CCLD
	# Bug: https://bugs.gentoo.org/730390
	unset LD
	if [[ -n "${CCLD}" ]]; then
		export LD="${CCLD}"
	fi
	perl-module_src_configure
}
src_compile() {
	./Build --config optimize="${CFLAGS}" build || die
}

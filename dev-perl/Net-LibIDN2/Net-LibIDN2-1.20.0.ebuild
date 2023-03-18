# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=THOR
DIST_VERSION=1.02
inherit perl-module

DESCRIPTION="Perl bindings for GNU Libidn2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="net-dns/libidn2:="
DEPEND="net-dns/libidn2:="
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-ParseXS
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.10.0
	)
"

src_configure() {
	unset LD
	[[ -n "${CCLD}" ]] && export LD="${CCLD}"
	perl-module_src_configure
}

src_compile() {
	./Build --config optimize="${CFLAGS}" build || die
}

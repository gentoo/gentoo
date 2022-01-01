# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHANCOCK
DIST_VERSION=20190915
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Perl script indenter and beautifier"
HOMEPAGE="http://perltidy.sourceforge.net/ https://metacpan.org/release/Perl-Tidy"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_install() {
	perl-module_src_install

	# Compressing html is bad
	docompress -x /usr/share/doc/${PF}/stylekey.html
	docompress -x /usr/share/doc/${PF}/tutorial.html
	docompress -x /usr/share/doc/${PF}/perltidy.html

	dodoc docs/stylekey.html
	dodoc docs/tutorial.html
	dodoc docs/perltidy.html
}

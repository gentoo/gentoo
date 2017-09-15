# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=v${PV}
DIST_AUTHOR=DTOWN
inherit perl-module

DESCRIPTION="A SNMP Perl Module"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~sparc-solaris ~x86-solaris"
# Package warrants IUSE examples
IUSE="examples test minimal"

RDEPEND="
	!minimal? (
		>=dev-perl/Crypt-DES-2.30.0
		>=dev-perl/Crypt-Rijndael-1.20.0
		>=dev-perl/Digest-HMAC-1.0
		>=virtual/perl-Digest-MD5-2.110.0
		>=dev-perl/Digest-SHA1-1.20.0
		>=dev-perl/Socket6-0.230.0
	)
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-IO
	virtual/perl-Math-BigInt
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	test? ( virtual/perl-Test )
"
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x usr/share/doc/${PF}/examples
		insinto usr/share/doc/${PF}/
		doins -r examples/
	fi
}

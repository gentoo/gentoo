# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GBARR
DIST_VERSION=2.16
inherit perl-module

DESCRIPTION="A Perl SASL interface"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="kerberos test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Digest-HMAC
	virtual/perl-Digest-MD5
	kerberos? ( dev-perl/GSSAPI )
"
BDEPEND="${DEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.42
	test? (
		virtual/perl-Test-Simple
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2.16-no-dot-inc.patch"
)

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_NAME=NTLM
DIST_AUTHOR=NBEBOUT
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="An NTLM authentication module"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/perl-MIME-Base64-3.00
	dev-perl/Digest-HMAC"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"
PERL_RM_FILES=(
	"t/99_pod.t"
)

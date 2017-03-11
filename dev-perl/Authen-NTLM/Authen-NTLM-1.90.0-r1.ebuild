# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=NTLM
MODULE_AUTHOR=NBEBOUT
MODULE_VERSION=1.09
inherit perl-module

DESCRIPTION="An NTLM authentication module"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND=">=virtual/perl-MIME-Base64-3.00
	dev-perl/Digest-HMAC"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do
export OPTIMIZE="$CFLAGS"

src_test() {
	perl_rm_files t/99_pod.t
	perl-module_src_test
}

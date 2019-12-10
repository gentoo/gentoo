# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MBRADSHAW
DIST_VERSION=0.41
DIST_EXAMPLES=("examples/*" "scripts/*")
inherit perl-module

DESCRIPTION="Signs/verifies Internet mail using DKIM message signatures"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/Crypt-OpenSSL-RSA-0.24
	virtual/perl-Digest-SHA
	virtual/perl-MIME-Base64
	dev-perl/Net-DNS
	dev-perl/MailTools"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
mydoc=("doc/*.txt" "HACKING.DKIM")

src_prepare() {
	# https://rt.cpan.org/Ticket/Display.html?id=121194
	mkdir -p "${S}"/examples || die "Can't mkdir ${S}/examples"
	mv "${S}"/sample_mime_lite.pl "${S}"/examples || die "Can't relocate sample_mime_lite"
	sed -i -e '/^sample_mime_lite.pl/d' MANIFEST || die "Can't fix manifest"
	perl-module_src_prepare
}
src_test(){
	# disable online tests
	perl_rm_files t/{policy,public_key,verifier,dev-manifest}.t
	perl-module_src_test
}

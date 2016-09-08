# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=NLNETLABS
DIST_VERSION=1.04
inherit toolchain-funcs perl-module

DESCRIPTION="Perl Net::DNS - Perl DNS Resolver Module"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="ipv6 test"

RDEPEND="
	>=dev-perl/Digest-HMAC-1.30.0
	>=virtual/perl-Digest-MD5-2.130.0
	>=virtual/perl-Digest-SHA-5.230.0
	>=virtual/perl-File-Spec-0.860.0
	>=virtual/perl-MIME-Base64-2.110.0
	ipv6? (
		dev-perl/IO-Socket-INET6
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

src_prepare() {
	perl-module_src_prepare
	mydoc="TODO"
	# --IPv6-tests requires that you have external IPv6 connectivity
	# as it connects to 2001:7b8:206:1:0:1234:be21:e31e
	myconf="${myconf} --no-online-tests --no-IPv6-tests"
}

src_compile() {
	emake FULL_AR="$(tc-getAR)" OTHERLDFLAGS="${LDFLAGS}"
}
src_test() {
	perl_rm_files t/00-pod.t
	perl-module_src_test
}

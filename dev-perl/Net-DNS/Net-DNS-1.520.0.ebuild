# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NLNETLABS
DIST_VERSION=1.52
DIST_EXAMPLES=( "contrib" "demo" )
inherit toolchain-funcs perl-module

DESCRIPTION="Perl Interface to the Domain Name System"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minimal"

PDEPEND="
	!minimal? ( >=dev-perl/Net-DNS-SEC-1.30.0 )
"
RDEPEND="
	>=dev-perl/Digest-HMAC-1.30.0
	!minimal? (
		>=dev-perl/Digest-BubbleBabble-0.20.0
		>=dev-perl/Net-LibIDN2-1.0.0
	)
"
BDEPEND="
	${RDEPEND}
"

src_prepare() {
	perl-module_src_prepare
	mydoc="TODO"
	# --IPv6-tests requires that you have external IPv6 connectivity
	# as it connects to 2001:7b8:206:1:0:1234:be21:e31e
	if ! use test || ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		myconf="${myconf} --no-online-tests --no-IPv6-tests"
	fi
}

src_compile() {
	emake FULL_AR="$(tc-getAR)" OTHERLDFLAGS="${LDFLAGS}"
}

src_test() {
	perl_rm_files t/00-pod.t
	if ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		elog "Network tests disabled without to DIST_TEST_OVERIDE=~network"
	fi
	perl-module_src_test
}
